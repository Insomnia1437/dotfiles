#!/bin/bash
# set -e # Keep commented out to attempt all selected installations
set -o pipefail
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
EPICS_ROOT_DIR=""
EPICS_ROOT_DIR_DEFAULT="${HOME}" # Default installation path (user's home)

# procServ related variables
PROCSERV_NAME="procServ"
PROCSERV_VERSION="2.8.0"
PROCSERV_ARCHIVE_NAME="${PROCSERV_NAME}-${PROCSERV_VERSION}.tar.gz"
PROCSERV_FOLDER_NAME="${PROCSERV_NAME}-${PROCSERV_VERSION}"
# tar file from procServ's tag page needs autoconf to generate configure script
# so we use release page to download
# PROCSERV_DOWNLOAD_URL="https://github.com/ralphlange/${PROCSERV_NAME}/archive/refs/tags/v${PROCSERV_VERSION}.tar.gz"
PROCSERV_DOWNLOAD_URL="https://github.com/ralphlange/${PROCSERV_NAME}/releases/download/v${PROCSERV_VERSION}/${PROCSERV_NAME}-${PROCSERV_VERSION}.tar.gz"

EXTENSIONS_TOP_ARCHIVE_NAME="extensionsTop_20120904.tar.gz"
EXTENSIONS_TOP_DOWNLOAD_URL="https://epics.anl.gov/download/extensions/${EXTENSIONS_TOP_ARCHIVE_NAME}"

# devlib2 related variables
DEVLIB2_NAME="devlib2"
DEVLIB2_VERSION="2.14"
DEVLIB2_ARCHIVE_NAME="${DEVLIB2_NAME}-${DEVLIB2_VERSION}.tar.gz"
DEVLIB2_FOLDER_NAME="${DEVLIB2_NAME}-${DEVLIB2_VERSION}"
DEVLIB2_DOWNLOAD_URL="https://github.com/epics-modules/${DEVLIB2_NAME}/archive/refs/tags/${DEVLIB2_VERSION}.tar.gz"

# mrfioc2 related variables
MRFIOC2_NAME="mrfioc2"
MRFIOC2_VERSION="2.7.2"
MRFIOC2_ARCHIVE_NAME="${MRFIOC2_NAME}-${MRFIOC2_VERSION}.tar.gz"
MRFIOC2_FOLDER_NAME="${MRFIOC2_NAME}-${MRFIOC2_VERSION}"
MRFIOC2_DOWNLOAD_URL="https://github.com/epics-modules/${MRFIOC2_NAME}/archive/refs/tags/${MRFIOC2_VERSION}.tar.gz"

# iocStats related variables
IOCSTATS_NAME="iocStats"
IOCSTATS_VERSION="4.0.0"
IOCSTATS_ARCHIVE_NAME="${IOCSTATS_NAME}-${IOCSTATS_VERSION}.tar.gz"
IOCSTATS_FOLDER_NAME="${IOCSTATS_NAME}-${IOCSTATS_VERSION}"
IOCSTATS_DOWNLOAD_URL="https://github.com/epics-modules/${IOCSTATS_NAME}/archive/refs/tags/${IOCSTATS_VERSION}.tar.gz"

# asyn related variables
ASYN_NAME="asyn"
ASYN_VERSION="4-45"
ASYN_ARCHIVE_NAME="${ASYN_NAME}-R${ASYN_VERSION}.tar.gz"
ASYN_FOLDER_NAME="${ASYN_NAME}-R${ASYN_VERSION}"
ASYN_DOWNLOAD_URL="https://github.com/epics-modules/${ASYN_NAME}/archive/refs/tags/R${ASYN_VERSION}.tar.gz"

# sequencer related variables
SEQUENCER_NAME="sequencer"
SEQUENCER_VERSION="2-2-9"
SEQUENCER_ARCHIVE_NAME="${SEQUENCER_NAME}-R${SEQUENCER_VERSION}.tar.gz"
SEQUENCER_FOLDER_NAME="${SEQUENCER_NAME}-R${SEQUENCER_VERSION}"
SEQUENCER_DOWNLOAD_URL="https://github.com/epics-modules/${SEQUENCER_NAME}/archive/refs/tags/R${SEQUENCER_VERSION}.tar.gz"


# for module selection
MODULE_KEYS=(${DEVLIB2_NAME} ${MRFIOC2_NAME} ${SEQUENCER_NAME} ${IOCSTATS_NAME} ${ASYN_NAME})
MODULE_DESC=(
    "devlib2 ${DEVLIB2_VERSION} (EPICS Device/Driver Library)"
    "mrfioc2 ${MRFIOC2_VERSION} (MRF Timing System Support)"
    "sequencer ${SEQUENCER_VERSION} (State Notation Language Sequencer)"
    "iocstats ${IOCSTATS_VERSION} (ioc status and host statistics)"
    "asyn ${ASYN_VERSION} (Asyn Support)"
)
MODULE_SELECTIONS=() # Array to store Y/N choices, parallel to MODULE_KEYS

# for EPICS Version Selection
EPICS_VERSIONS_LIST=(
    "7.0.10"   # Typical URL: https://epics.anl.gov/download/base/base-7.0.10.tar.gz
    "7.0.9"    # Typical URL: https://epics.anl.gov/download/base/base-7.0.9.tar.gz
    "7.0.8"  # Typical URL: https://epics.anl.gov/download/base/base-7.0.8.tar.gz
    "3.15.9"   # Typical URL: https://epics.anl.gov/download/base/base-3.15.9.tar.gz
)

BASE_DOWNLOAD_URL_PREFIXES="https://epics.anl.gov/download/base/base-"
BASE_DOWNLOAD_URL_SUFFIXES=".tar.gz"
EPICS_VERSION="" # Will be set based on user selection
BASE_DOWNLOAD_URL="" # Will be set based on user selection
BASE_ARCHIVE_NAME="" # Will be set based on user selection
BASE_PATH_NAME_RAW="" # Will be set based on user selection

# epics path structure
EPICS_TOP_DIR="" # Will be set based on user selection
EPICS_DOWNLOADS_DIR="" # Will be set based on user selection
EPICS_BASE_DIR="" # Will be set based on user selection
EPICS_MODULE_DIR="" # Will be set based on user selection
EPICS_IOC_DIR="" # Will be set based on user selection
EPICS_EXTENSIONS_DIR="" # Will be set based on user selection

# others
NOW=""
CPU_CORES=""
#### Global Variables ##############

# Check if a command exists
check_cmd() {
    if ! [ -x "$(command -v $1)" ]; then
        _red "Command ${red}$1${green} is required but not found. Please install $1."
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

get_cpu_cores() {
    local raw_cores
    local jobs
    if command -v nproc > /dev/null 2>&1; then
        raw_cores=$(nproc) # Linux
    elif command -v sysctl > /dev/null 2>&1; then
        raw_cores=$(sysctl -n hw.ncpu) # macOS
    else
        raw_cores=1 # default to 1 if command not found
    fi

    # let's reserve 2 cores for system responsiveness
    jobs=$(( raw_cores > 8 ? 8 : raw_cores-2 ))
    if [ "$jobs" -lt 1 ]; then
        echo 1
    else
        echo "$jobs"
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
                "aarch64")
                    EPICS_HOST_ARCH="linux-aarch64"
                    ;;
                *)
                    EPICS_HOST_ARCH="linux-unknown_arch"
                    ;;
            esac
            ;;
        "Darwin")
            case "$arch_type" in
                x86_64|i386)
                    EPICS_HOST_ARCH="darwin-x86" # Intel Mac
                    ;;
                arm64|aarch64)
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
    _magenta "==============================================="
    _cyan "Detected OS Type: $os_type, Architecture Type: $arch_type"
    _cyan "EPICS_HOST_ARCH set to: $EPICS_HOST_ARCH"
    _magenta "===============================================\n"
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

is_module_installed() {
    local module_name="$1"
    local module_path="$2"
    local check_file="$3"  # File to check for module completion (e.g., lib/libxxx.a)

    if [ -d "${module_path}" ] && [ -f "${check_file}" ]; then
        _green "${module_name} is already installed at ${module_path}"
        _green "Found ${module_path}/${check_file}"
        _green "Skipping ${module_name} installation.\n"
        return 0  # Module is installed
    else
        return 1  # Module is not installed
    fi
}

# Helper function: download file if not already present
download_file() {
    local url="$1"
    local filename="$2"
    local download_dir="$3"

    cd "${download_dir}" || { _red "Failed to cd to ${download_dir}"; return 1; }

    if [ -f "${filename}" ]; then
        _yellow "${filename} already exists. Skipping download."
        return 0
    fi

    _cyan "Downloading ${filename} from ${url} to ${download_dir}..."
    wget -c --timeout=30 "${url}" -O "${filename}"
    if [ $? -ne 0 ]; then
        _red "Failed to download ${filename}"
        return 1
    fi
    return 0
}

# Helper function: extract archive
extract_archive() {
    local filename="$1"
    local target_dir="$2"

    _cyan "Extracting ${filename} to ${target_dir}"
    tar -zxf "${filename}" -C "${target_dir}"
    if [ $? -ne 0 ]; then
        _red "Failed to extract ${filename}"
        return 1
    fi
    return 0
}

install_base() {
    # --- Install EPICS Base ---
    _cyan "=== Installing EPICS base ===\n"
    download_file "${BASE_DOWNLOAD_URL}" "${BASE_ARCHIVE_NAME}" "${EPICS_DOWNLOADS_DIR}" || return 1

    extract_archive "${BASE_ARCHIVE_NAME}" "${EPICS_TOP_DIR}" || return 1

    _yellow "Changing to EPICS TOP directory: ${EPICS_TOP_DIR}"
    cd "${EPICS_TOP_DIR}" || { _red "Failed to cd to ${EPICS_TOP_DIR}"; return 1; }

    if [ -d "${BASE_PATH_NAME_RAW}" ]; then
        _cyan "Found extracted base at ${BASE_PATH_NAME_RAW}, renaming to 'base'."
        # Remove existing 'base' directory if it's a symlink or an old non-compiled directory to avoid mv issues
        if [ -L "base" ] || [ -d "base" ]; then
            _yellow "Removing existing 'base' directory/symlink before renaming."
            mv "${EPICS_BASE_DIR}" "${EPICS_BASE_DIR}-old-${NOW}"
        fi
        mv "${BASE_PATH_NAME_RAW}" "${EPICS_BASE_DIR}"
        if [ $? -ne 0 ]; then
            _red "Failed to rename extracted base directory to 'base'."
            return 1
        fi
    else
        _red "Could not find extracted EPICS base directory (expected: ${BASE_PATH_NAME_RAW}). Please check archive content and extraction path."
        # List contents of EPICS_TOP_DIR for debugging
        ls -l "${EPICS_TOP_DIR}"
        return 1
    fi

    _yellow "Changing to EPICS Base directory: ${EPICS_BASE_DIR}"
    cd "${EPICS_BASE_DIR}" || return 1
    _cyan "=== Building EPICS Base (${EPICS_VERSION}) This may take a while ===\n"
    make -j ${CPU_CORES} 2>&1 | tee "${EPICS_BASE_DIR}/make-base-${EPICS_VERSION}-${NOW}.log"
    if [ $? -ne 0 ]; then
        _red "EPICS Base build failed!"
        return 1
    fi
    _green "=== EPICS base installed successfully ===\n"
    return 0
}

# procServ installation function
install_procserv() {

    _cyan "=== Installing ${PROCSERV_NAME} (${PROCSERV_VERSION}) ===\n"
    # Download and extract extensionsTop first
    download_file "${EXTENSIONS_TOP_DOWNLOAD_URL}" "${EXTENSIONS_TOP_ARCHIVE_NAME}" "${EPICS_DOWNLOADS_DIR}" || return 1
    extract_archive "${EXTENSIONS_TOP_ARCHIVE_NAME}" "${EPICS_TOP_DIR}" || return 1

    # Download procServ
    download_file "${PROCSERV_DOWNLOAD_URL}" "${PROCSERV_ARCHIVE_NAME}" "${EPICS_DOWNLOADS_DIR}" || return 1
    # Extract procServ
    mkdir -p "${EPICS_EXTENSIONS_DIR}/src"
    extract_archive "${PROCSERV_ARCHIVE_NAME}" "${EPICS_EXTENSIONS_DIR}/src" || return 1

    local PROCSERV_SRC_PATH="${EPICS_EXTENSIONS_DIR}/src/${PROCSERV_FOLDER_NAME}"
    if [ ! -d "${PROCSERV_SRC_PATH}" ]; then
        _red "Extracted ${PROCSERV_NAME} directory ${PROCSERV_SRC_PATH} not found."
        ls -l "${EPICS_EXTENSIONS_DIR}/src/"
        return 1
    fi

    # Configure
    cd "${PROCSERV_SRC_PATH}" || { _red "Failed to cd to ${PROCSERV_NAME} source."; return 1; }
    _cyan "Configuring ${PROCSERV_NAME}..."
    ./configure --enable-access-from-anywhere --with-epics-top="../.." 2>&1 | tee "${PROCSERV_SRC_PATH}/configure-${PROCSERV_FOLDER_NAME}-${NOW}.log"
    if [ $? -ne 0 ]; then
        _red "Failed to configure ${PROCSERV_NAME}."
        return 1
    fi

    # Build
    _cyan "=== Building ${PROCSERV_NAME} ===\n"
    make 2>&1 | tee "${EPICS_EXTENSIONS_DIR}/make-${PROCSERV_FOLDER_NAME}-${NOW}.log"
    if [ $? -ne 0 ]; then
        _red "${PROCSERV_NAME} build failed. Check log for details."
        return 1
    fi

    _green "=== ${PROCSERV_NAME} installed successfully ===\n"
    return 0
}

# common module installation function
module_src_prep() {
    local module_name="$1"
    local module_version="$2"
    local module_archive_name="$3"
    local module_folder_name="$4"
    local module_download_url="$5"

    local module_src_path="${EPICS_MODULE_DIR}/${module_folder_name}"

    _cyan "=== Installing ${module_name} ===\n"
    download_file "${module_download_url}" "${module_archive_name}" "${EPICS_DOWNLOADS_DIR}" || return 1
    extract_archive "${module_archive_name}" "${EPICS_MODULE_DIR}" || return 1

    if [ ! -d "${module_src_path}" ]; then
        _red "Extracted ${module_name} directory ${module_src_path} not found."
        ls -l "${EPICS_MODULE_DIR}"
        return 1
    fi

    cd "${module_src_path}" || { _red "Failed to cd to ${module_name} source."; return 1; }
    return 0
}
module_src_build() {
    local module_name="$1"
    local module_src_path="$2"

    cd "${module_src_path}" || { _red "Failed to cd to ${module_name} source."; return 1; }
    _cyan "Set EPICS_BASE to configure/RELEASE.local..."
    echo "EPICS_BASE=${EPICS_BASE_DIR}" >> configure/RELEASE.local
    if [ $? -ne 0 ]; then
        _red "Failed to write ${module_name} RELEASE.local"
        return 1
    fi

    _cyan "=== Building ${module_name} ===\n"
    make 2>&1 | tee "${module_src_path}/make-${module_name}-${NOW}.log"
    if [ $? -ne 0 ]; then
        _red "${module_name} build failed. Check log for details."
        return 1
    fi
    _green "=== ${module_name} installed successfully ===\n"
    return 0
}


to_bashrc() {
    echo "$1" >> ${HOME}/.bashrc
}

install_epics() {
    EPICS_ROOT_DIR="$1"
    CPU_CORES=$(get_cpu_cores)
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

    _cyan "EPICS Version Selection:"
    for i in "${!EPICS_VERSIONS_LIST[@]}"; do
        printf "  %d) %s\n" "$((i+1))" "${EPICS_VERSIONS_LIST[$i]}"
    done

    local choice
    local yn_choice
    local file_after_make=""

    while true; do
        read -p "Select EPICS version to install (1-${#EPICS_VERSIONS_LIST[@]}): " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#EPICS_VERSIONS_LIST[@]}" ]; then
            EPICS_VERSION="${EPICS_VERSIONS_LIST[$((choice-1))]}"
            EPICS_TOP_DIR="${EPICS_ROOT_DIR}/epics/R${EPICS_VERSION}"
            EPICS_DOWNLOADS_DIR="${EPICS_ROOT_DIR}/epics/downloads"
            EPICS_BASE_DIR="${EPICS_TOP_DIR}/base"
            EPICS_MODULE_DIR="${EPICS_TOP_DIR}/modules"
            EPICS_IOC_DIR="${EPICS_TOP_DIR}/ioc"
            EPICS_EXTENSIONS_DIR="${EPICS_TOP_DIR}/extensions"

            BASE_DOWNLOAD_URL="${BASE_DOWNLOAD_URL_PREFIXES}${EPICS_VERSION}${BASE_DOWNLOAD_URL_SUFFIXES}"
            BASE_ARCHIVE_NAME="base-${EPICS_VERSION}.tar.gz"
            BASE_PATH_NAME_RAW="${EPICS_BASE_DIR}-${EPICS_VERSION}"
            _magenta "==============================================="
            _cyan "Selected EPICS version: ${EPICS_VERSION}"
            _cyan "Download URL: ${BASE_DOWNLOAD_URL}"
            _cyan "Archive name for download: ${BASE_ARCHIVE_NAME}"
            _magenta "===============================================\n"
            break
        else
            _yellow "Invalid selection. Please enter a number between 1 and ${#EPICS_VERSIONS_LIST[@]}."
        fi
    done
    
    _magenta "==============================================="
    _cyan "EPICS ROOT set to: ${EPICS_ROOT_DIR}"
    _cyan "EPICS TOP set to: ${EPICS_TOP_DIR}"
    _cyan "EPICS base set to: ${EPICS_BASE_DIR}"
    _cyan "EPICS modules set to: ${EPICS_MODULE_DIR}"
    _cyan "EPICS ioc set to: ${EPICS_IOC_DIR}"
    _cyan "EPICS extensions set at: ${EPICS_EXTENSIONS_DIR}"
    _cyan "Downloads will be in: ${EPICS_DOWNLOADS_DIR}"
    _magenta "===============================================\n"
    
    # create necessary directories
    # donot create base and extensions here, they will be renamed after extraction
    mkdir -p "${EPICS_TOP_DIR}"
    mkdir -p "${EPICS_MODULE_DIR}"
    mkdir -p "${EPICS_IOC_DIR}"
    mkdir -p "${EPICS_DOWNLOADS_DIR}"

    # --- Module Selection ---
    _cyan "=== EPICS Module Selection ===\n"

    for i in "${!MODULE_KEYS[@]}"; do
        local m_key="${MODULE_KEYS[$i]}"
        local m_desc="${MODULE_DESC[$i]}"

        while true; do
            read -p "Install module: ${m_desc}? (Y/N): " yn_choice
            yn_choice=$(echo "${yn_choice}" | tr '[:lower:]' '[:upper:]')
            if [[ "$yn_choice" == "Y" || "$yn_choice" == "N" ]]; then
                MODULE_SELECTIONS[$i]=$yn_choice # Store selection
                if [[ "$yn_choice" == "Y" ]]; then
                    _cyan "${m_key} will be installed."
                else
                    _yellow "${m_key} will NOT be installed."
                fi
                break
            else
                _red "Invalid input. Please enter Y or N."
            fi
        done
    done

    # --- Handle mrfioc2 dependencies ---
    # If mrfioc2 is selected but devlib2 is not, auto-select devlib2
    if [[ "$(get_module_selection "${MRFIOC2_NAME}")" == "Y" && "$(get_module_selection "${DEVLIB2_NAME}")" == "N" ]]; then
        _cyan "mrfioc2 depends on devlib2. Auto-enabling devlib2 installation."
        for i in "${!MODULE_KEYS[@]}"; do
            if [[ "${MODULE_KEYS[$i]}" == ${DEVLIB2_NAME} ]]; then
                MODULE_SELECTIONS[$i]="Y"
                break
            fi
        done
    fi
    if [[ "$(get_module_selection "${SEQUENCER_NAME}")" == "Y" ]]; then
        _cyan "Sequencer requires re2c for building. Checking for re2c..."
        check_cmd re2c # sequencer build dependency
        _green "re2c found. sequencer build should work fine.\n"
    fi
    
    if [[ "$(get_module_selection "${ASYN_NAME}")" == "Y" && "${EPICS_HOST_ARCH}" == linux* ]]; then
        _cyan "asyn requires TIRPC for building on Linux. Checking for TIRPC..."
        if [[ -f "/usr/include/tirpc/rpc/rpc.h" ]]; then
            _green "TIRPC header file found. asyn build should work fine.\n"
        else
            _yellow "TIRPC header file not found in /usr/include/tirpc/rpc/rpc.h."
            _yellow "Please install TIRPC development package and re-run this script."
            _yellow "  - Debian/Ubuntu: sudo apt install libtirpc-dev"
            _yellow "  - RHEL/CentOS/Fedora: sudo dnf install libtirpc-devel"
            exit 1
        fi
    fi

    # see asyn issue #223, hope this will be fixed soon so that we can remove this workaround
    if [[ "$(get_module_selection "${ASYN_NAME}")" == "Y" && ${EPICS_VERSION} == "3.15.9" ]]; then
        _cyan "EPICS version ${EPICS_VERSION} and asyn version ${ASYN_VERSION} are selected"
        _cyan "But asyn-R4-44 and later have compatibility issues with EPICS 3.15.9"
        _yellow "Change asyn version to ${ASYN_VERSION} for compatibility with EPICS 3.15.9\n"
        # asyn related variables
        ASYN_NAME="asyn"
        ASYN_VERSION="4-43"
        ASYN_ARCHIVE_NAME="${ASYN_NAME}-R${ASYN_VERSION}.tar.gz"
        ASYN_FOLDER_NAME="${ASYN_NAME}-R${ASYN_VERSION}"
        ASYN_DOWNLOAD_URL="https://github.com/epics-modules/${ASYN_NAME}/archive/refs/tags/R${ASYN_VERSION}.tar.gz"
    fi


    file_after_make="${EPICS_BASE_DIR}/bin/${EPICS_HOST_ARCH}/softIoc"
    # Check if EPICS Base is already installed
    if ! is_module_installed "EPICS Base" "${EPICS_BASE_DIR}" "${file_after_make}"; then
        install_base || { _red "Failed to install EPICS Base. Aborting."; exit 1; }
    fi

    # --- Install Optional Modules ---
    _cyan "=== Installing Optional Modules ===\n"

    # Check if procServ is already installed
    file_after_make="${EPICS_EXTENSIONS_DIR}/bin/${EPICS_HOST_ARCH}/${PROCSERV_NAME}"
    if ! is_module_installed "${PROCSERV_NAME}"  "${EPICS_EXTENSIONS_DIR}" "${file_after_make}"; then
        install_procserv || { _red "Failed to install ${PROCSERV_NAME}. Aborting."; exit 1; }
    fi


    # Install devlib2 if selected
    if [[ "$(get_module_selection "${DEVLIB2_NAME}")" == "Y" ]]; then
        # Check if devlib2 is already installed
        local DEVLIB2_SRC_PATH="${EPICS_MODULE_DIR}/${DEVLIB2_FOLDER_NAME}"
        file_after_make="${DEVLIB2_SRC_PATH}/dbd/epicspci.dbd"
        if ! is_module_installed "${DEVLIB2_NAME}"  "${DEVLIB2_SRC_PATH}" "${file_after_make}"; then
            module_src_prep "${DEVLIB2_NAME}" "${DEVLIB2_VERSION}" "${DEVLIB2_ARCHIVE_NAME}" "${DEVLIB2_FOLDER_NAME}" "${DEVLIB2_DOWNLOAD_URL}" || { _red "Failed to prepare ${DEVLIB2_NAME} source. Aborting."; exit 1; }
            module_src_build "${DEVLIB2_NAME}" "${DEVLIB2_SRC_PATH}" || { _red "Failed to build ${DEVLIB2_NAME}. Aborting."; exit 1; }
        fi
    fi


    # Install mrfioc2 if selected
    if [[ "$(get_module_selection "${MRFIOC2_NAME}")" == "Y" ]]; then
        # Check if mrfioc2 is already installed
        local MRFIOC2_SRC_PATH="${EPICS_MODULE_DIR}/${MRFIOC2_FOLDER_NAME}"
        file_after_make="${MRFIOC2_SRC_PATH}/dbd/mrf.dbd"
        if ! is_module_installed "${MRFIOC2_NAME}"  "${MRFIOC2_SRC_PATH}" "${file_after_make}"; then
            module_src_prep "${MRFIOC2_NAME}" "${MRFIOC2_VERSION}" "${MRFIOC2_ARCHIVE_NAME}" "${MRFIOC2_FOLDER_NAME}" "${MRFIOC2_DOWNLOAD_URL}" || { _red "Failed to prepare ${MRFIOC2_NAME} source. Aborting."; exit 1; }
            # extra setup
            cd "${MRFIOC2_SRC_PATH}" || { _red "Failed to cd to ${MRFIOC2_NAME} source."; exit 1; }
            echo "DEVLIB2=${DEVLIB2_SRC_PATH}" >> configure/RELEASE.local
            module_src_build "${MRFIOC2_NAME}" "${MRFIOC2_SRC_PATH}" || { _red "Failed to build ${MRFIOC2_NAME}. Aborting."; exit 1; }
        fi
    fi


    # Install sequencer if selected
    if [[ "$(get_module_selection "${SEQUENCER_NAME}")" == "Y" ]]; then
        # Check if sequencer is already installed
        local SEQUENCER_SRC_PATH="${EPICS_MODULE_DIR}/${SEQUENCER_FOLDER_NAME}"
        file_after_make="${SEQUENCER_SRC_PATH}/lib/${EPICS_HOST_ARCH}/libseq.a"
        if ! is_module_installed "${SEQUENCER_NAME}"  "${SEQUENCER_SRC_PATH}" "${file_after_make}"; then
            module_src_prep "${SEQUENCER_NAME}" "${SEQUENCER_VERSION}" "${SEQUENCER_ARCHIVE_NAME}" "${SEQUENCER_FOLDER_NAME}" "${SEQUENCER_DOWNLOAD_URL}" || { _red "Failed to prepare ${SEQUENCER_NAME} source. Aborting."; exit 1; }
            module_src_build "${SEQUENCER_NAME}" "${SEQUENCER_SRC_PATH}" || { _red "Failed to build ${SEQUENCER_NAME}. Aborting."; exit 1; }
        fi
    fi

    # Install iocStats if selected
    if [[ "$(get_module_selection "${IOCSTATS_NAME}")" == "Y" ]]; then
        # Check if iocStats is already installed
        local IOCSTATS_SRC_PATH="${EPICS_MODULE_DIR}/${IOCSTATS_FOLDER_NAME}"
        file_after_make="${IOCSTATS_SRC_PATH}/lib/${EPICS_HOST_ARCH}/libdevIocStats.a"
        if ! is_module_installed "${IOCSTATS_NAME}"  "${IOCSTATS_SRC_PATH}" "${file_after_make}"; then
            module_src_prep "${IOCSTATS_NAME}" "${IOCSTATS_VERSION}" "${IOCSTATS_ARCHIVE_NAME}" "${IOCSTATS_FOLDER_NAME}" "${IOCSTATS_DOWNLOAD_URL}" || { _red "Failed to prepare ${IOCSTATS_NAME} source. Aborting."; exit 1; }
            # extra setup
            cd "${IOCSTATS_SRC_PATH}" || { _red "Failed to cd to ${IOCSTATS_NAME} source."; exit 1; }
            echo "MAKE_TEST_IOC_APP=NO" >> configure/RELEASE.local
            module_src_build "${IOCSTATS_NAME}" "${IOCSTATS_SRC_PATH}" || { _red "Failed to build ${IOCSTATS_NAME}. Aborting."; exit 1; }
        fi
    fi

    # Install asyn if selected
    if [[ "$(get_module_selection "${ASYN_NAME}")" == "Y" ]]; then
        # Check if asyn is already installed
        local ASYN_SRC_PATH="${EPICS_MODULE_DIR}/${ASYN_FOLDER_NAME}"
        file_after_make="${ASYN_SRC_PATH}/lib/${EPICS_HOST_ARCH}/libasyn.a"
        if ! is_module_installed "${ASYN_NAME}"  "${ASYN_SRC_PATH}" "${file_after_make}"; then
            module_src_prep "${ASYN_NAME}" "${ASYN_VERSION}" "${ASYN_ARCHIVE_NAME}" "${ASYN_FOLDER_NAME}" "${ASYN_DOWNLOAD_URL}" || { _red "Failed to prepare ${ASYN_NAME} source. Aborting."; exit 1; }
            # extra setup
            cd "${ASYN_SRC_PATH}" || { _red "Failed to cd to ${ASYN_NAME} source."; exit 1; }
            echo "SUPPORT=${EPICS_MODULE_DIR}" >> configure/RELEASE.local
            case ${EPICS_HOST_ARCH} in
                linux*)
                    _cyan "Enabling TIRPC on Linux..."
                    echo "TIRPC=YES" >> configure/CONFIG_SITE.local
                ;;
            esac
            module_src_build "${ASYN_NAME}" "${ASYN_SRC_PATH}" || { _red "Failed to build ${ASYN_NAME}. Aborting."; exit 1; }
        fi
    fi


    _cyan "=== EPICS Installation Script Finished ===\n"
    _cyan "EPICS Base Version: ${EPICS_VERSION}"
    _cyan "Installed to: ${EPICS_TOP_DIR}"
    _cyan "Remember to set up your environment variables to use this EPICS installation.\n"

    read -e -p "Do you want to set up EPICS ENVs now? (Y/N): " yn_choice
    yn_choice=$(echo "${yn_choice}" | tr '[:lower:]' '[:upper:]')
    if [[ "$yn_choice" == "Y" ]]; then
        if grep -q "EPICS_BASE_DIR" ${HOME}/.bashrc; then
            _yellow "EPICS environment variables already exist in ${HOME}/.bashrc, skipping."
        else
            # add env to bashrc
            _cyan "add EPICS env to ${HOME}/.bashrc"
            to_bashrc ""
            to_bashrc "export EPICS_BASE_DIR=${EPICS_BASE_DIR}"
            to_bashrc "export EPICS_HOST_ARCH=${EPICS_HOST_ARCH}"
            to_bashrc "export EPICS_IOCSH_HISTFILE=''"
            to_bashrc "alias cdb='cd ${EPICS_BASE_DIR}'"
            to_bashrc "alias cdm='cd ${EPICS_MODULE_DIR}'"
            to_bashrc "alias cdi='cd ${EPICS_IOC_DIR}'"
            to_bashrc "export PATH=${EPICS_EXTENSIONS_DIR}/bin/${EPICS_HOST_ARCH}:${EPICS_BASE_DIR}/bin/${EPICS_HOST_ARCH}:\${PATH}"
            to_bashrc ""
        fi
    fi
}

help() {
    _cyan "Usage: $0 [option]"
    _cyan "Options:"
    _cyan "  1 - Install EPICS to a user-defined path (default: ${EPICS_ROOT_DIR_DEFAULT})"
    _cyan "  2 - Install EPICS to /tmp (for testing)"
    _cyan "  h - Display this help message"
    exit 1
}

# Check argument count
if [ "$#" -gt 1 ]; then # Allow 0 or 1 argument
    _red "Too many arguments."
    help
fi

# Process argument
case $1 in
    1)
        read -e -p "Enter the target installation path [default: ${EPICS_ROOT_DIR_DEFAULT}]: " user_path
        EPICS_ROOT_DIR="${user_path:-${EPICS_ROOT_DIR_DEFAULT}}" # Use default if user_path is empty
        if [[ ! -d "$EPICS_ROOT_DIR" ]]; then
            _red "Error: ${EPICS_ROOT_DIR} is not a valid path"
            exit 1
        fi
        _green "Selected installation path: ${EPICS_ROOT_DIR}"
        install_epics "${EPICS_ROOT_DIR}";;
    2)
        _green "Selected installation path: /tmp"
        install_epics "/tmp";;
    h | --help | -h )
        help;;
    *)
        _red "Invalid option: $1"
        help;;
esac

