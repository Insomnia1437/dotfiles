#!/usr/bin/env bash

set -e

declare -A MODULE_REPO

MODULE_REPO["asyn"]="https://github.com/epics-modules/asyn"
MODULE_REPO["stream"]="https://github.com/paulscherrerinstitute/StreamDevice"
MODULE_REPO["calc"]="https://github.com/epics-modules/calc"
MODULE_REPO["sequencer"]="https://github.com/epics-modules/sequencer"
MODULE_REPO["iocStats"]="https://github.com/epics-modules/iocStats"
MODULE_REPO["procServ"]="https://github.com/ralphlange/procServ"
MODULE_REPO["base"]="https://github.com/epics-base/epics-base"
MODULE_REPO["motor"]="https://github.com/epics-modules/motor"
MODULE_REPO["busy"]="https://github.com/epics-modules/busy"
MODULE_REPO["caPutLog"]="https://github.com/epics-modules/caPutLog"
MODULE_REPO["autosave"]="https://github.com/epics-modules/autosave"
MODULE_REPO["devlib2"]="https://github.com/epics-modules/devlib2"
MODULE_REPO["mrfioc2"]="https://github.com/epics-modules/mrfioc2"
MODULE_REPO["MCoreUtils"]="https://github.com/epics-modules/MCoreUtils"

declare -A MODULE_VERSIONS

MODULE_VERSIONS["asyn"]="R4-38 R4-44 R4-45"
MODULE_VERSIONS["stream"]="2.8.22 2.8.24 2.8.26"
MODULE_VERSIONS["calc"]="R3-6-1 R3-7-4 R3-7-5"
MODULE_VERSIONS["sequencer"]="R2-2-2 R2-2-8 R2-2-9"
MODULE_VERSIONS["iocStats"]="3.1.16 3.2.0 4.0.0 4.0.1"
MODULE_VERSIONS["procServ"]="v2.6.0 v2.7.0 v2.8.0"
MODULE_VERSIONS["base"]="R3.15.9 R7.0.7 R7.0.8 R7.0.9 R7.0.10"
MODULE_VERSIONS["motor"]="R7-0 R7-3-1 R7-4"
MODULE_VERSIONS["busy"]="R1-7 R1-7-3 R1-7-4"
MODULE_VERSIONS["caPutLog"]="R3.5 R3.7 R4.0 R4.2"
MODULE_VERSIONS["autosave"]="R5-7-1 R5-8 R5-10 R5-11 R6-0"
MODULE_VERSIONS["devlib2"]="2.5 2.9 2.11 2.12 2.13 2.14"
MODULE_VERSIONS["mrfioc2"]="2.0.2 2.1.0 2.2.0 2.6.0 2.7.2"
MODULE_VERSIONS["MCoreUtils"]="1.2 1.2.2 1.2.3"

echo "========================================"
echo "      EPICS Module Downloader"
echo "========================================"
echo ""

############################################
# Step 1: Select Module
############################################
modules=( $(echo "${!MODULE_REPO[@]}" | tr ' ' '\n' | sort) )

PS3="Select a module (or 'Quit'): "
COLUMNS=1
select mod in "${modules[@]}" "Quit"; do
    if [[ "$mod" == "Quit" ]]; then
        exit 0
    elif [[ -n "$mod" ]]; then
        SELECTED_MODULE=$mod
        break
    else
        echo "Invalid selection."
    fi
done

############################################
# Step 2: Select Version
############################################
echo -e "\nModule: $SELECTED_MODULE"
versions=( ${MODULE_VERSIONS[$SELECTED_MODULE]} )

PS3="Select a version for $SELECTED_MODULE: "

select ver in "${versions[@]}" "Manual Input" "Back"; do
    case $ver in
        "Back")
            exec "$0" # Restart the script
            ;;
        "Manual Input")
            read -p "Enter custom version (e.g., R4-38): " SELECTED_VER
            break
            ;;
        "")
            if [[ -n "$ver" ]]; then
                SELECTED_VER=$ver
                break
            else
                echo "Invalid selection."
            fi
            ;;
        *)
            SELECTED_VER=$ver
            break
            ;;
    esac
done

############################################
# Step 3: Check and Download
############################################
REPO_URL="${MODULE_REPO[$SELECTED_MODULE]}"
DOWNLOAD_URL="${REPO_URL}/archive/refs/tags/${SELECTED_VER}.tar.gz"
OUTPUT_FILE="${SELECTED_MODULE}-${SELECTED_VER}.tar.gz"

echo -e "\nTarget: $OUTPUT_FILE"
echo "URL:    $DOWNLOAD_URL"
echo -e "Checking availability...\n"

if wget --spider -q "$DOWNLOAD_URL"; then
    echo "URL verified. Starting download..."
    wget -O "$OUTPUT_FILE" "$DOWNLOAD_URL"
    echo -e "\nSuccess: $OUTPUT_FILE saved."
else
    echo "ERROR: The version '$SELECTED_VER' was not found on the server."
    echo "Please check if the tag exists at: ${REPO_URL}/tags"
    exit 1
fi
