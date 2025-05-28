#!/bin/bash
# set -e # Keep commented out to attempt all selected installations

#### Colorized output ##############
red='\033[31m'
yellow='\033[33m'
gray='\033[90m'
green='\033[92m'
blue='\033[94m'
magenta='\033[95m'
cyan='\033[96m'
none='\033[0m'

red_bg='\033[41m'
green_bg='\033[42m'
yellow_bg='\033[43m'
blue_bg='\033[44m'
magenta_bg='\033[45m'
cyan_bg='\033[46m'

reset_color='\033[39m'
reset_bgcolor='\033[49m'
reset_all='\033[0m'

_red() { printf "${red}$@${none}\n"; }
_blue() { printf "${blue}$@${none}\n"; }
_cyan() { printf "${cyan}$@${none}\n"; }
_green() { printf "${green}$@${none}\n"; }
_yellow() { printf "${yellow}$@${none}\n"; }
_magenta() { printf "${magenta}$@${none}\n"; }

_green_bg() { printf "${green_bg}$@${reset_bgcolor}\n"; }
_red_bg() { printf "${red_bg}$@${reset_bgcolor}\n"; }
#### Colorize output ##############

#### Global Variables ##############
TARGET_PATH=""
TARGET_PATH_DEFAULT="${HOME}" # Default installation path (user's home)
#### Global Variables ##############

# Check if a command exists
check_cmd() {
    if ! [ -x "$(command -v $1)" ]; then
        _green "Command ${red}$1${green} is required but not found. Please install $1."
        exit 1
    fi
    return 0
}

# Function to ask for reboot (not called by default in this script flow)
confirm_and_reboot() {
    read -p "It seems everything works fine. Ready to reboot? (Y/N): " user_input
    user_input=$(echo "${user_input}" | tr '[:lower:]' '[:upper:]')
    if [ "$user_input" == "Y" ]; then
        _red_bg "Rebooting..."
        sudo reboot now
    else
        _cyan "Exiting without reboot."
    fi
}
set_epics_host_arch() {
    local os_type=$(uname -s)
    local arch_type=$(uname -m)

    EPICS_HOST_ARCH="unknown"

    case "$os_type" in
        "Linux")
            case "$arch_type" in
                "x86_64")
                    EPICS_HOST_ARCH="linux-x86_64"
                    ;;
                "i*86")
                    EPICS_HOST_ARCH="linux-x86"
                    ;;
                "arm*")
                    EPICS_HOST_ARCH="linux-arm"
                    ;;
                *)
                    EPICS_HOST_ARCH="linux-unknown_arch"
                    ;;
            esac
            ;;
        "Darwin")
            case "$arch_type" in
                "x86_64" | i386)
                    EPICS_HOST_ARCH="darwin-x86" # Intel Mac
                    ;;
                "arm*")
                    EPICS_HOST_ARCH="darwin-arm64" # Apple Silicon
                    ;;
                *)
                    EPICS_HOST_ARCH="darwin-unknown_arch" # PowerPC Mac still alive?
                    ;;
            esac
            ;;
        *)
            _red "Warning: Neither Linux nor Darwin detected ($os_type). EPICS_HOST_ARCH remains 'unknown'."
            ;;
    esac

    export EPICS_HOST_ARCH
    _cyan "Detected OS Type: $os_type, Architecture Type: $arch_type"
    _cyan "EPICS_HOST_ARCH set to: $EPICS_HOST_ARCH"
}

install_epics() {
    local EPICS_ROOT_DIR="$1" # Installation directory (e.g., /tmp or ${HOME})
    local NOW
    NOW=$(date '+%Y%m%d_%H%M%S')

    # --- Check required commands ---
    _cyan "Checking prerequisite commands..."
    check_cmd make
    check_cmd tee
    check_cmd perl
    check_cmd git
    check_cmd wget
    _cyan "All prerequisite commands found."

    set_epics_host_arch

    # --- EPICS Version Selection ---
    local EPICS_VERSIONS_LIST=(
        "7.0.8.1"  # Typical URL: https://epics.anl.gov/download/base/base-7.0.8.1.tar.gz
        "7.0.9"    # Typical URL: https://epics.anl.gov/download/base/base-7.0.7.tar.gz
        "3.15.9"   # Typical URL: https://epics.anl.gov/download/base/base-3.15.9.tar.gz
    )
    local EPICS_VERSION_URL_PREFIXES="https://epics.anl.gov/download/base/base-"
    local EPICS_VERSION_URL_SUFFIXES=".tar.gz"


    _cyan "EPICS Version Selection:"
    for i in "${!EPICS_VERSIONS_LIST[@]}"; do
        printf "  %d) %s\n" "$((i+1))" "${EPICS_VERSIONS_LIST[$i]}"
    done

    local choice
    local yn_choice
    local EPICS_VERSION
    local EPICS_BASE_DOWNLOAD_URL
    local EPICS_BASE_ARCHIVE_NAME
    local EXTRACTED_BASE_DIR_NAME_PATTERN # Used to find the dir after extraction

    while true; do
        read -p "Select EPICS version to install (1-${#EPICS_VERSIONS_LIST[@]}): " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#EPICS_VERSIONS_LIST[@]}" ]; then
            EPICS_VERSION="${EPICS_VERSIONS_LIST[$((choice-1))]}"
            EPICS_BASE_DOWNLOAD_URL="${EPICS_VERSION_URL_PREFIXES}${EPICS_VERSION}${EPICS_VERSION_URL_SUFFIXES}"

            EPICS_BASE_ARCHIVE_NAME="base-${EPICS_VERSION}.tar.gz"
            EXTRACTED_BASE_DIR_NAME_PATTERN="base-${EPICS_VERSION}"

            _cyan "Selected EPICS version: ${EPICS_VERSION}"
            _cyan "Download URL: ${EPICS_BASE_DOWNLOAD_URL}"
            _cyan "Archive name for download: ${EPICS_BASE_ARCHIVE_NAME}"
            break
        else
            _yellow "Invalid selection. Please enter a number between 1 and ${#EPICS_VERSIONS_LIST[@]}."
        fi
    done

    # --- EPICS Paths Setup ---
    local EPICS_TOP="${EPICS_ROOT_DIR}/epics/R${EPICS_VERSION}"
    local EPICS_DOWNLOADS_DIR="${EPICS_ROOT_DIR}/epics/downloads"
    local EPICS_BASE="${EPICS_TOP}/base"
    local EPICS_MODULE_DIR="${EPICS_TOP}/modules"
    local EPICS_IOC_DIR="${EPICS_TOP}/ioc"
    local EPICS_EXTENSIONS_DIR="${EPICS_TOP}/extensions"

    mkdir -p "${EPICS_TOP}"
    mkdir -p "${EPICS_DOWNLOADS_DIR}"
    mkdir -p "${EPICS_IOC_DIR}"
    mkdir -p "${EPICS_MODULE_DIR}"

    _cyan "EPICS_ROOT set to: ${EPICS_ROOT_DIR}"
    _cyan "EPICS_TOP will be: ${EPICS_TOP}"
    _cyan "EPICS modules at: ${EPICS_MODULE_DIR}"
    _cyan "EPICS ioc at: ${EPICS_IOC_DIR}"
    _cyan "EPICS extensions at: ${EPICS_EXTENSIONS_DIR}"
    _cyan "Downloads will be in: ${EPICS_DOWNLOADS_DIR}"

    # --- Module Selection ---
    _cyan "EPICS Module Selection:"
    # Module specific versions (from original script)
    local DEVLIB2_VERSION="2.12"
    local IOCSTATS_VERSION="3.2.0"
    local ASYN_VERSION="4-45"
    local PROCSERV_VERSION="2.8.0" # Used for procServ
    # Global (within function scope) arrays for module selection
    MODULE_KEYS=("devlib2" "mrfioc2" "iocstats" "asyn")
    MODULE_FRIENDLY_NAMES=(
        "devlib2 (EPICS Device/Driver Library)"
        "mrfioc2 (MRF Timing System Support)"
        "iocStats (IOC Status and Statistics)"
        "asyn (Asyn Support)"
    )
    MODULE_SELECTIONS=() # Array to store Y/N choices, parallel to MODULE_KEYS

    for i in "${!MODULE_KEYS[@]}"; do
        local key="${MODULE_KEYS[$i]}"
        local name="${MODULE_FRIENDLY_NAMES[$i]}"

        while true; do
            read -p "Install module: ${name}? (Y/N): " yn_choice
            yn_choice=$(echo "${yn_choice}" | tr '[:lower:]' '[:upper:]')
            if [[ "$yn_choice" == "Y" || "$yn_choice" == "N" ]]; then
                MODULE_SELECTIONS[$i]=$yn_choice # Store selection
                if [[ "$yn_choice" == "Y" ]]; then
                    _cyan "${name} will be installed."
                else
                    _yellow "${name} will NOT be installed."
                fi
                break
            else
                _yellow "Invalid input. Please enter Y or N."
            fi
        done
    done

    # --- Install EPICS Base ---
    _yellow "Changing to downloads directory: ${EPICS_DOWNLOADS_DIR}"
    cd "${EPICS_DOWNLOADS_DIR}" || { _red "Failed to cd to ${EPICS_DOWNLOADS_DIR}"; exit 1; }

    _cyan "Downloading EPICS Base (${EPICS_VERSION})..."
    if [ -f "${EPICS_BASE_ARCHIVE_NAME}" ]; then
        _yellow "EPICS Base archive ${EPICS_BASE_ARCHIVE_NAME} already exists. Skipping download."
    else
        wget "${EPICS_BASE_DOWNLOAD_URL}" -O "${EPICS_BASE_ARCHIVE_NAME}"
        if [ $? -ne 0 ]; then
            _red "Failed to download EPICS Base. Check URL and network."
            exit 1
        fi
    fi

    _cyan "Extracting EPICS Base..."
    tar -zxf "${EPICS_BASE_ARCHIVE_NAME}" -C "${EPICS_TOP}"
    if [ $? -ne 0 ]; then
        _red "Failed to extract EPICS Base."
        exit 1
    fi

    _yellow "Changing to EPICS TOP directory: ${EPICS_TOP}"
    cd "${EPICS_TOP}" || { _red "Failed to cd to ${EPICS_TOP}"; exit 1; }

    local extracted_base_actual_path="${EPICS_TOP}/${EXTRACTED_BASE_DIR_NAME_PATTERN}"
    if [ -d "${extracted_base_actual_path}" ]; then
        _cyan "Found extracted base at ${extracted_base_actual_path}, renaming to 'base'."
        # Remove existing 'base' directory if it's a symlink or an old directory to avoid mv issues
        if [ -L "base" ] || [ -d "base" ]; then
            _yellow "Removing existing 'base' directory/symlink before renaming."
            mv  "base" "base-old-${NOW}"
        fi
        mv "${extracted_base_actual_path}" base
        if [ $? -ne 0 ]; then
            _red "Failed to rename extracted base directory to 'base'."
            exit 1
        fi
    else
        _red "Could not find extracted EPICS base directory (expected: ${extracted_base_actual_path}). Please check archive content and extraction path."
        # List contents of EPICS_TOP for debugging
        ls -l "${EPICS_TOP}"
        exit 1
    fi

    _yellow "Changing to EPICS Base directory: ${EPICS_BASE}"
    cd "${EPICS_BASE}" || { _red "Failed to cd to ${EPICS_BASE}"; exit 1; }
    _cyan "Building EPICS Base (${EPICS_VERSION})... This may take a while."
    make 2>&1 | tee "${EPICS_DOWNLOADS_DIR}/make-base-${EPICS_VERSION}-${NOW}.log"

    # make runtests 2>&1 | tee "${EPICS_DOWNLOADS_DIR}/make-base-runtests-${EPICS_VERSION}-${NOW}.log"

    # Install procServ (and extensionsTop)
    local EXTENSIONS_TOP_ARCHIVE_FILENAME="extensionsTop_20120904.tar.gz" # As per original script
    local EXTENSIONS_TOP_URL="https://epics.anl.gov/download/extensions/${EXTENSIONS_TOP_ARCHIVE_FILENAME}"

    local PROCSERV_MODULE_NAME="procServ" # Base name
    local PROCSERV_SRC_DIR_NAME="${PROCSERV_MODULE_NAME}-${PROCSERV_VERSION}"
    local PROCSERV_ARCHIVE_FILENAME="${PROCSERV_MODULE_NAME}-${PROCSERV_VERSION}.tar.gz"
    local PROCSERV_DOWNLOAD_URL="https://github.com/ralphlange/procServ/releases/download/v${PROCSERV_VERSION}/${PROCSERV_ARCHIVE_FILENAME}"

    _cyan "--- Installing procServ (${PROCSERV_VERSION}) (includes extensionsTop) ---"
    _yellow "Changing to downloads directory: ${EPICS_DOWNLOADS_DIR}"
    cd "${EPICS_DOWNLOADS_DIR}" || { _red "Failed to cd to ${EPICS_DOWNLOADS_DIR}. Skipping procServ."; continue; }

    # Download and extract extensionsTop first
    _cyan "Downloading extensionsTop..."
    if [ -f "${EXTENSIONS_TOP_ARCHIVE_FILENAME}" ]; then
        _yellow "${EXTENSIONS_TOP_ARCHIVE_FILENAME} already exists. Skipping download."
    else
        wget "${EXTENSIONS_TOP_URL}" -O "${EXTENSIONS_TOP_ARCHIVE_FILENAME}"
        if [ $? -ne 0 ]; then _red "Failed to download extensionsTop. Skipping procServ."; continue; fi
    fi

    _cyan "Extracting extensionsTop..."
    # This creates ${EPICS_TOP}/extensions directory
    tar -zxf "${EXTENSIONS_TOP_ARCHIVE_FILENAME}" -C "${EPICS_TOP}"
    if [ $? -ne 0 ]; then _red "Failed to extract extensionsTop. Skipping procServ."; continue; fi

    # Now handle procServ
    _cyan "Downloading procServ..."
    if [ -f "${PROCSERV_ARCHIVE_FILENAME}" ]; then
        _yellow "${PROCSERV_ARCHIVE_FILENAME} already exists. Skipping download."
    else
        wget "${PROCSERV_DOWNLOAD_URL}" -O "${PROCSERV_ARCHIVE_FILENAME}"
        if [ $? -ne 0 ]; then _red "Failed to download procServ. Skipping."; continue; fi
    fi

    _cyan "Extracting procServ..."
    # procServ is extracted into ${EPICS_EXTENSIONS_DIR}/src/
    mkdir -p "${EPICS_EXTENSIONS_DIR}/src"
    tar -zxf "${PROCSERV_ARCHIVE_FILENAME}" -C "${EPICS_EXTENSIONS_DIR}/src"
    if [ $? -ne 0 ]; then _red "Failed to extract procServ. Skipping."; continue; fi

    local PROCSERV_FULL_SRC_PATH="${EPICS_EXTENSIONS_DIR}/src/${PROCSERV_SRC_DIR_NAME}"
        if [ ! -d "${PROCSERV_FULL_SRC_PATH}" ]; then
        _red "Extracted procServ directory ${PROCSERV_FULL_SRC_PATH} not found. Skipping build."
        ls -l "${EPICS_EXTENSIONS_DIR}/src/" # Debug output
        continue
    fi

    _yellow "Changing to procServ source directory: ${PROCSERV_FULL_SRC_PATH}"
    cd "${PROCSERV_FULL_SRC_PATH}" || { _red "Failed to cd to procServ source. Skipping."; continue; }

    _cyan "Configuring procServ..."
    # Using absolute path for --with-epics-top for robustness
    ./configure --enable-access-from-anywhere --with-epics-top="../.." 2>&1 | tee "${EPICS_DOWNLOADS_DIR}/configure-${PROCSERV_SRC_DIR_NAME}-${NOW}.log"


    _cyan "Building procServ..."
    make 2>&1 | tee "${EPICS_DOWNLOADS_DIR}/make-${PROCSERV_SRC_DIR_NAME}-${NOW}.log"

    # Install devlib2 if selected
    if [[ "$(get_module_selection 'devlib2')" == "Y" ]]; then
        local DEVLIB2_MODULE_NAME="devlib2" # Base name
        local DEVLIB2_SRC_DIR_NAME="${DEVLIB2_MODULE_NAME}-${DEVLIB2_VERSION}" # Expected dir name after extraction
        local DEVLIB2_ARCHIVE_FILENAME="${DEVLIB2_MODULE_NAME}-${DEVLIB2_VERSION}.tar.gz" # Archive name for wget -O
        local DEVLIB2_DOWNLOAD_URL="https://github.com/epics-modules/devlib2/archive/refs/tags/${DEVLIB2_VERSION}.tar.gz"

        _cyan "--- Installing devlib2 (${DEVLIB2_VERSION}) ---"
        _yellow "Changing to downloads directory: ${EPICS_DOWNLOADS_DIR}"
        cd "${EPICS_DOWNLOADS_DIR}" || { _red "Failed to cd to ${EPICS_DOWNLOADS_DIR}"; continue; } # Continue to next module if cd fails

        _cyan "Downloading devlib2..."
        if [ -f "${DEVLIB2_ARCHIVE_FILENAME}" ]; then
             _yellow "${DEVLIB2_ARCHIVE_FILENAME} already exists. Skipping download."
        else
            wget "${DEVLIB2_DOWNLOAD_URL}" -O "${DEVLIB2_ARCHIVE_FILENAME}"
            if [ $? -ne 0 ]; then _red "Failed to download devlib2. Skipping."; continue; fi
        fi

        _cyan "Extracting devlib2..."
        tar -zxf "${DEVLIB2_ARCHIVE_FILENAME}" -C "${EPICS_MODULE_DIR}"
        if [ $? -ne 0 ]; then _red "Failed to extract devlib2. Skipping."; continue; fi

        local DEVLIB2_FULL_SRC_PATH="${EPICS_MODULE_DIR}/${DEVLIB2_SRC_DIR_NAME}"
        if [ ! -d "${DEVLIB2_FULL_SRC_PATH}" ]; then
            _red "Extracted devlib2 directory ${DEVLIB2_FULL_SRC_PATH} not found. Skipping build."
            ls -l "${EPICS_MODULE_DIR}" # Debug output
            continue
        fi

        _yellow "Changing to devlib2 source directory: ${DEVLIB2_FULL_SRC_PATH}"
        cd "${DEVLIB2_FULL_SRC_PATH}" || { _red "Failed to cd to devlib2 source. Skipping."; continue; }

        _cyan "Configuring devlib2..."
        echo "EPICS_BASE=${EPICS_BASE}" > configure/RELEASE.local # Overwrite if exists, or create

        _cyan "Building devlib2..."
        make 2>&1 | tee "${EPICS_DOWNLOADS_DIR}/make-${DEVLIB2_SRC_DIR_NAME}-${NOW}.log"

    fi

    # Install mrfioc2 if selected
    if [[ "$(get_module_selection 'mrfioc2')" == "Y" ]]; then
        local MRFIOC2_MODULE_NAME="mrfioc2" # Base name and git repo name
        local MRFIOC2_GIT_URL="https://github.com/Insomnia1437/mrfioc2.git"
        local MRFIOC2_FULL_SRC_PATH="${EPICS_MODULE_DIR}/${MRFIOC2_MODULE_NAME}"

        _cyan "--- Installing mrfioc2 (from git) ---"
        _yellow "Changing to EPICS modules directory: ${EPICS_MODULE_DIR}"
        cd "${EPICS_MODULE_DIR}" || { _red "Failed to cd to ${EPICS_MODULE_DIR}. Skipping mrfioc2."; continue; }

        if [ -d "${MRFIOC2_FULL_SRC_PATH}" ]; then
            _yellow "mrfioc2 directory already exists. Assuming it's already cloned or manually placed. Skipping clone."
            _yellow "If you need a fresh clone, please remove ${MRFIOC2_FULL_SRC_PATH} and re-run."
        else
            _cyan "Cloning mrfioc2..."
            git clone "${MRFIOC2_GIT_URL}" "${MRFIOC2_FULL_SRC_PATH}"
            if [ $? -ne 0 ]; then _red "Failed to clone mrfioc2. Skipping."; continue; fi
        fi

        _yellow "Changing to mrfioc2 source directory: ${MRFIOC2_FULL_SRC_PATH}"
        cd "${MRFIOC2_FULL_SRC_PATH}" || { _red "Failed to cd to mrfioc2 source. Skipping."; continue; }

        _cyan "Configuring mrfioc2..."
        echo "EPICS_BASE=${EPICS_BASE}" > configure/RELEASE.local # Overwrite or create
        if [[ "$(get_module_selection 'devlib2')" == "Y" ]]; then
            local DEVLIB2_INSTALLED_PATH="${EPICS_MODULE_DIR}/devlib2-${DEVLIB2_VERSION}"
            if [ -d "${DEVLIB2_INSTALLED_PATH}" ]; then
                echo "DEVLIB2=${DEVLIB2_INSTALLED_PATH}" >> configure/RELEASE.local
                _cyan "Added DEVLIB2 path to mrfioc2 RELEASE.local"
            else
                _yellow "devlib2 was selected, but its directory ${DEVLIB2_INSTALLED_PATH} not found. DEVLIB2 path not added to mrfioc2 RELEASE.local."
            fi
        else
            _yellow "devlib2 was not selected. mrfioc2 might fail to build if it strictly requires devlib2 at build time."
        fi

        _cyan "Building mrfioc2..."
        make 2>&1 | tee "${EPICS_DOWNLOADS_DIR}/make-${MRFIOC2_MODULE_NAME}-${NOW}.log"
    fi

    # Install iocStats if selected
    if [[ "$(get_module_selection 'iocstats')" == "Y" ]]; then
        local IOCSTATS_MODULE_NAME="iocStats" # Base name
        local IOCSTATS_SRC_DIR_NAME="${IOCSTATS_MODULE_NAME}-${IOCSTATS_VERSION}"
        local IOCSTATS_ARCHIVE_FILENAME="${IOCSTATS_MODULE_NAME}-${IOCSTATS_VERSION}.tar.gz"
        local IOCSTATS_DOWNLOAD_URL="https://github.com/epics-modules/iocStats/archive/refs/tags/${IOCSTATS_VERSION}.tar.gz"

        _cyan "--- Installing iocStats (${IOCSTATS_VERSION}) ---"
        _yellow "Changing to downloads directory: ${EPICS_DOWNLOADS_DIR}"
        cd "${EPICS_DOWNLOADS_DIR}" || { _red "Failed to cd to ${EPICS_DOWNLOADS_DIR}. Skipping iocStats."; continue; }

        _cyan "Downloading iocStats..."
        if [ -f "${IOCSTATS_ARCHIVE_FILENAME}" ]; then
            _yellow "${IOCSTATS_ARCHIVE_FILENAME} already exists. Skipping download."
        else
            wget "${IOCSTATS_DOWNLOAD_URL}" -O "${IOCSTATS_ARCHIVE_FILENAME}"
            if [ $? -ne 0 ]; then _red "Failed to download iocStats. Skipping."; continue; fi
        fi

        _cyan "Extracting iocStats..."
        tar -zxf "${IOCSTATS_ARCHIVE_FILENAME}" -C "${EPICS_MODULE_DIR}"
        if [ $? -ne 0 ]; then _red "Failed to extract iocStats. Skipping."; continue; fi

        local IOCSTATS_FULL_SRC_PATH="${EPICS_MODULE_DIR}/${IOCSTATS_SRC_DIR_NAME}"
        if [ ! -d "${IOCSTATS_FULL_SRC_PATH}" ]; then
            _red "Extracted iocStats directory ${IOCSTATS_FULL_SRC_PATH} not found. Skipping build."
            ls -l "${EPICS_MODULE_DIR}" # Debug output
            continue
        fi

        _yellow "Changing to iocStats source directory: ${IOCSTATS_FULL_SRC_PATH}"
        cd "${IOCSTATS_FULL_SRC_PATH}" || { _red "Failed to cd to iocStats source. Skipping."; continue; }

        _cyan "Configuring iocStats..."
        echo "EPICS_BASE=${EPICS_BASE}" > configure/RELEASE.local
        echo "MAKE_TEST_IOC_APP=NO" >> configure/RELEASE.local

        _cyan "Building iocStats..."
        make 2>&1 | tee "${EPICS_DOWNLOADS_DIR}/make-${IOCSTATS_SRC_DIR_NAME}-${NOW}.log"
    fi


    # Install asyn if selected
    if [[ "$(get_module_selection 'asyn')" == "Y" ]]; then
        local ASYN_MODULE_NAME="asyn" # Base name
        local ASYN_SRC_RAW_DIR_NAME="${ASYN_MODULE_NAME}-R${ASYN_VERSION}"  # asyn-R4-45
        local ASYN_SRC_DIR_NAME="${ASYN_MODULE_NAME}-${ASYN_VERSION}"       # asyn-4-45
        local ASYN_ARCHIVE_FILENAME="${ASYN_MODULE_NAME}-R${ASYN_VERSION}.tar.gz"
        local ASYN_DOWNLOAD_URL="https://github.com/epics-modules/asyn/archive/refs/tags/R${ASYN_VERSION}.tar.gz"

        _cyan "--- Installing asyn (${ASYN_VERSION}) ---"
        _yellow "Changing to downloads directory: ${EPICS_DOWNLOADS_DIR}"
        cd "${EPICS_DOWNLOADS_DIR}" || { _red "Failed to cd to ${EPICS_DOWNLOADS_DIR}. Skipping asyn."; continue; }

        _cyan "Downloading asyn..."
        if [ -f "${ASYN_ARCHIVE_FILENAME}" ]; then
            _yellow "${ASYN_ARCHIVE_FILENAME} already exists. Skipping download."
        else
            wget "${ASYN_DOWNLOAD_URL}" -O "${ASYN_ARCHIVE_FILENAME}"
            if [ $? -ne 0 ]; then _red "Failed to download asyn. Skipping."; continue; fi
        fi

        _cyan "Extracting asyn..."
        tar -zxf "${ASYN_ARCHIVE_FILENAME}" -C "${EPICS_MODULE_DIR}"
        if [ $? -ne 0 ]; then _red "Failed to extract asyn. Skipping."; continue; fi

        local ASYN_FULL_SRC_PATH="${EPICS_MODULE_DIR}/${ASYN_SRC_RAW_DIR_NAME}"
        if [ ! -d "${ASYN_FULL_SRC_PATH}" ]; then
            _red "Extracted asyn directory ${ASYN_FULL_SRC_PATH} not found. Skipping build."
            ls -l "${EPICS_MODULE_DIR}" # Debug output
            continue
        fi

        cd "${EPICS_MODULE_DIR}" || { _red "Failed to cd to ${EPICS_MODULE_DIR}. Skipping asyn."; continue; }
        _cyan "rename asyn directory name..."
        mv -f ${ASYN_SRC_RAW_DIR_NAME} ${ASYN_SRC_DIR_NAME}
        if [ $? -ne 0 ]; then _red "Failed to rename asyn directory. Skipping."; continue; fi

        local ASYN_FULL_SRC_PATH="${EPICS_MODULE_DIR}/${ASYN_SRC_DIR_NAME}"
        _yellow "Changing to asyn source directory: ${ASYN_FULL_SRC_PATH}"
        cd "${ASYN_FULL_SRC_PATH}" || { _red "Failed to cd to asyn source. Skipping."; continue; }

        _cyan "Configuring asyn..."
        echo "SUPPORT=${EPICS_MODULE_DIR}" >> configure/RELEASE.local
        echo "EPICS_BASE=${EPICS_BASE}" > configure/RELEASE.local

        case ${EPICS_HOST_ARCH} in
            Linux*)
                _cyan "enable TIRPC on Linux..."
                echo "TIRPC=YES" > configure/CONFIG_SITE.local
                ;;
        esac

        _cyan "Building asyn..."
        make 2>&1 | tee "${EPICS_DOWNLOADS_DIR}/make-${ASYN_SRC_DIR_NAME}-${NOW}.log"
    fi


    _cyan "--- EPICS Installation Script Finished ---"
    _cyan "EPICS Base Version: ${EPICS_VERSION}"
    _cyan "Installed to: ${EPICS_TOP}"
    _cyan "Selected modules processed. Check logs in ${EPICS_DOWNLOADS_DIR} for details."
    _cyan "Remember to set up your environment variables (e.g., EPICS_HOST_ARCH, PATH, EPICS_BASE) to use this EPICS installation."

    read -e -p "Do you want to set up EPICS ENVs now? (Y/N): " yn_choice
    yn_choice=$(echo "${yn_choice}" | tr '[:lower:]' '[:upper:]')
    if [[ "$yn_choice" == "Y" ]]; then
        if grep -q "EPICS_BASE" ${HOME}/.bashrc; then
            _yellow "EPICS environment variables already exist in ${HOME}/.bashrc, skipping."
        else
            # add env to bashrc
            _cyan "add EPICS env to ${HOME}/.bashrc"
            to_bashrc "export EPICS_BASE=${EPICS_BASE}"
            to_bashrc "export EPICS_HOST_ARCH=${EPICS_HOST_ARCH}"
            to_bashrc "alias cdb='cd ${EPICS_BASE}'"
            to_bashrc "alias cdm='cd ${EPICS_MODULE_DIR}'"
            to_bashrc "alias cdi='cd ${EPICS_IOC_DIR}'"
            to_bashrc "export PATH='${EPICS_EXTENSIONS_DIR}/bin/${EPICS_HOST_ARCH}:${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:${PATH}'"
            to_bashrc ""
        fi
    fi
}

get_module_selection() {
    local key_to_find="$1"
    for i in "${!MODULE_KEYS[@]}"; do
        if [[ "${MODULE_KEYS[$i]}" == "$key_to_find" ]]; then
            echo "${MODULE_SELECTIONS[$i]}"
            return
        fi
    done
    echo "N" # Default to N if not found, though should not happen
}

to_bashrc() {
    echo $1 >> ${HOME}/.bashrc
}


help() {
    _cyan "Usage: $0 [option]"
    _cyan "Options:"
    _cyan "  1 - Install EPICS to a user-defined path (default: ${TARGET_PATH_DEFAULT})"
    _cyan "  2 - Install EPICS to /tmp (for testing)"
    _cyan "  h - Display this help message"
    exit 1
}

# Check argument count
if [ "$#" -gt 1 ]; then # Allow 0 or 1 argument
    _red "Too many arguments."
    help
fi

# if [ "$#" -eq 0 ]; then # No arguments, default to option 1 with default path
#     _cyan "No option specified, proceeding with default installation to ${TARGET_PATH_DEFAULT}"
#     read -p "Install EPICS to ${TARGET_PATH_DEFAULT}? (Y/N, default Y): " confirm_default
#     confirm_default=${confirm_default^^}
#     if [[ "$confirm_default" == "N" ]]; then
#         _yellow "Installation aborted by user."
#         exit 0
#     fi
#     install_epics "${TARGET_PATH_DEFAULT}"
#     exit 0
# fi

# Process argument
case $1 in
    1)
        read -e -p "Enter the target installation path [default: ${TARGET_PATH_DEFAULT}]: " user_path
        TARGET_PATH="${user_path:-${TARGET_PATH_DEFAULT}}" # Use default if user_path is empty
        if [[ ! -d "$TARGET_PATH" ]]; then
            _red "Error: ${TARGET_PATH} is not a valid path"
            exit 1
        fi
        _green "Selected installation path: ${TARGET_PATH}"
        install_epics "${TARGET_PATH}";;
    2)
        _green "Selected installation path: /tmp"
        install_epics "/tmp";;
    h | --help | -h )
        help;;
    *)
        _red "Invalid option: $1"
        help;;
esac

