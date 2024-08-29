#!/bin/bash
# set -e
# bash fonts colors
red='\e[31m'
yellow='\e[33m'
gray='\e[90m'
green='\e[92m'
blue='\e[94m'
magenta='\e[95m'
cyan='\e[96m'
none='\e[0m'
_red() { echo -e ${red}$@${none}; }
_blue() { echo -e ${blue}$@${none}; }
_cyan() { echo -e ${cyan}$@${none}; }
_green() { echo -e ${green}$@${none}; }
_yellow() { echo -e ${yellow}$@${none}; }
_magenta() { echo -e ${magenta}$@${none}; }
_red_bg() { echo -e "\e[41m$@${none}"; }
# check command exist
check_cmd() {
    if ! [ -x "$(command -v git)" ]; then
        _red_bg "Need ${yellow}($1)${none}... please install $1"
        exit 1
    fi
    return 0
}
# to_bashrc() {
#     echo $1 >> ${HOME}/.bashrc
# }
confirm_and_reboot() {
    read -p "It seems everything works fine.\nReady to reboot?(Y/N): " user_input
    # not case sensitive, Y/y
    user_input=${user_input^^}

    if [ "$user_input" == "Y" ]; then
        _cyan "reboot..."
        sudo reboot now
    else
        _cyan "exit..."
        return
    fi
}
install_epics() {
    check_cmd make
    check_cmd tee
    check_cmd perl
    check_cmd git
    check_cmd wget

    # source ~/.bashrc
    # mount -t nfs acc-nas2:/data /accnas2
    NOW=`date '+%Y%m%d_%H%M%S'`

    EPICS_ROOT=$1
    #EPICS_ROOT=/tmp
    EPICS_VERSION="7.0.8"
    EPICS_TOP="${EPICS_ROOT}/epics/R${EPICS_VERSION}"
    EPICS_DOWNLOADS=${EPICS_ROOT}/epics/downloads
    mkdir -p ${EPICS_DOWNLOADS}
    mkdir -p ${EPICS_TOP}/{ioc,modules}
    EPICS_BASE=${EPICS_TOP}/base
    # export EPICS_HOST_ARCH=linux-x86_64
    EPICS_MODULE=${EPICS_TOP}/modules
    EPICS_IOC=${EPICS_TOP}/ioc
    EPICS_EXTENSION=${EPICS_TOP}/extensions
    DEVLIB2_VERSION="2.12"
    DEVLIB2="devlib2-${DEVLIB2_VERSION}"
    MRFIOC2="mrfioc2"
    IOCSTATS_VERSION="3.2.0"
    IOCSTATS="iocStats-{IOCSTATS_VERSION}"
    PROCSERV_VERSION="2.8.0"
    PROCSERV="procServ-${PROCSERV_VERSION}"

    _yellow "Go to ${EPICS_DOWNLOADS}"
    cd ${EPICS_DOWNLOADS}

    _cyan "Download epics base..."
    wget https://epics.anl.gov/download/base/base-${EPICS_VERSION}.tar.gz -O base-${EPICS_VERSION}.tar.gz
    tar -zxf base-${EPICS_VERSION}.tar.gz -C ${EPICS_TOP}
    _yellow "Go to ${EPICS_TOP}"
    cd ${EPICS_TOP}
    mv base-${EPICS_VERSION} base

    _yellow "Go to ${EPICS_BASE}"
    cd ${EPICS_BASE}
    _cyan "Build epics base..."
    make 2>&1 | tee make-base-${NOW}.log
    # make runtests 2>&1 | tee make-base-runtests-${NOW}.log

    _yellow "Go to ${EPICS_DOWNLOADS}"
    cd ${EPICS_DOWNLOADS}
    _cyan "Download devlib2..."
    wget https://github.com/epics-modules/devlib2/archive/refs/tags/2.12.tar.gz -O ${DEVLIB2}.tar.gz
    tar -zxf ${DEVLIB2}.tar.gz -C ${EPICS_MODULE}

    _cyan "Download mrfioc2..."
    git clone https://github.com/Insomnia1437/mrfioc2.git ${EPICS_MODULE}/${MRFIOC2}

    _cyan "Download iocStats..."
    wget https://github.com/epics-modules/iocStats/archive/refs/tags/3.2.0.tar.gz -O ${IOCSTATS}.tar.gz
    tar -zxf ${IOCSTATS}.tar.gz -C ${EPICS_MODULE}

    _cyan "Download extensions top..."
    wget https://epics.anl.gov/download/extensions/extensionsTop_20120904.tar.gz -O extensions.tar.gz
    tar -zxf extensions.tar.gz -C ${EPICS_TOP}

    _cyan "Download procServ..."
    wget https://github.com/ralphlange/procServ/releases/download/v2.8.0/procServ-2.8.0.tar.gz -O ${PROCSERV}.tar.gz
    tar -zxf ${PROCSERV}.tar.gz -C ${EPICS_EXTENSION}/src

    _yellow "Go to ${EPICS_MODULE}/${DEVLIB2}"
    cd ${EPICS_MODULE}/${DEVLIB2}
    echo "EPICS_BASE=${EPICS_BASE}" >> configure/RELEASE.local
    _cyan "Build ${DEVLIB2}..."
    make 2>&1 | tee ${DEVLIB2}-make-${NOW}.log

    _yellow "Go to ${EPICS_MODULE}/${MRFIOC2}"
    cd ${EPICS_MODULE}/${MRFIOC2}
    echo "DEVLIB2=${EPICS_MODULE}/${DEVLIB2}" >> configure/RELEASE.local
    echo "EPICS_BASE=${EPICS_BASE}" >> configure/RELEASE.local
    _cyan "Build ${MRFIOC2}..."
    make 2>&1 | tee make-${MRFIOC2}-${NOW}.log

    _yellow "Go to ${EPICS_MODULE}/${IOCSTATS}"
    cd ${EPICS_MODULE}/${IOCSTATS}
    echo "MAKE_TEST_IOC_APP=NO" >> configure/RELEASE.local
    echo "EPICS_BASE=${EPICS_BASE}" >> configure/RELEASE.local
    _cyan "Build ${IOCSTATS}..."
    make 2>&1 | tee make-${IOCSTATS}-${NOW}.log

    _yellow "Go to ${EPICS_EXTENSION}/src/${PROCSERV}"
    cd ${EPICS_EXTENSION}/src/${PROCSERV}
    _cyan "Build ${PROCSERV}..."
    ./configure --enable-access-from-anywhere --with-epics-top=../.. 2>&1 | tee configure-${PROCSERV}-${NOW}.log
    make 2>&1 | tee make-${PROCSERV}-${NOW}.log

    _cyan "finish..."
}

help() {
    _cyan "Help: $0 [option]"
    _cyan "Option:"
    _cyan "  1 - install epics to ${HOME}"
    _cyan "  2 - test install epics to /tmp"
    exit 1
}
# check arg number
if [ "$#" -ne 1 ]; then
    help
fi

# run function of different stages
case $1 in
    1)
        install_epics ${HOME};;
    2)
        install_epics /tmp;;
    *)
        help
        exit 1
        ;;
esac