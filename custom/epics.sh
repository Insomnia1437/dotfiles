# EPICS
uname=`uname`
arch=`uname -m`
case $uname in
"Linux")
        HOST_ARCH="linux-${arch}"
        ;;
"Darwin")
        HOST_ARCH="darwin-x86"
        ;;
esac

# add Raspberry PI 4B (armv7l)
case $arch in
"armv7l")
        HOST_ARCH="linux-arm"
        ;;
esac

# for vxworks in linac
if [ -e '/cont/VxWorks/vw68' ];then
        export  WIND_HOME='/cont/VxWorks/vw68'
fi

export  EPICS_BASE="${Home}/epics/R3.14.12.8/base"
export  EPICS_HOST_ARCH=${HOST_ARCH}
export  EPICS_EXTENSIONS="$EPICS_BASE/../extensions"
export  EPICS_CA_MAX_ARRAY_BYTES=10000000
# export EPICS_CA_AUTO_ADDR_LIST NO
# export EPICS_CA_ADDR_LIST='172.19.64.78'
export  PATH=$EPICS_BASE/bin/$EPICS_HOST_ARCH:$PATH
export  PATH=${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}:$PATH

alias cdb="cd ${EPICS_BASE}"
alias cde="cd ${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}"
alias cdi="cd ${EPICS_BASE}/../ioc"
alias cdd="cd ${HOME}/epics/download"
alias cdp="cd ${HOME}/workspace/python"
