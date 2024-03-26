# change EPICS
# match EPICS version
old_epics_version=${EPICS_VERSION}
if [[ -n old_epics_version ]]; then
# to match the colon. Should colon be escaped?
    old_path1="${HOME}/epics/${old_epics_version}/base/bin/${EPICS_HOST_ARCH}\(:\)\{0,1\}"
    old_path2="${HOME}/epics/${old_epics_version}/extensions/bin/${EPICS_HOST_ARCH}\(:\)\{0,1\}"
    old_path3="${HOME}/epics/${old_epics_version}/base/lib/${EPICS_HOST_ARCH}\(:\)\{0,1\}"
    # remove old path for epics base and extesion
    # use "#" for sed to avoid escape of "/"
    export  PATH=$(echo ${PATH} | sed "s#${old_path1}##g")
    export  PATH=$(echo ${PATH} | sed "s#${old_path2}##g")
    export  LD_LIBRARY_PATH=$(echo ${LD_LIBRARY_PATH} | sed "s#${old_path3}##g")
    # keep the environment clean
    unset old_epics_version old_path1 old_path2 old_path3
fi

if [[ $1 = R3* || $1 = R7* ]]; then
    EPICS_VERSION=$1
    echo "Use EPICS $1"
else
    # EPICS_VERSION="R3.14.12.8"
    EPICS_VERSION="R7.0.8"
fi
export  EPICS_VERSION="${EPICS_VERSION}"
export  EPICS_BASE="${HOME}/epics/${EPICS_VERSION}/base"
export  EPICS_EXTENSIONS="${HOME}/epics/${EPICS_VERSION}/extensions"
export  EPICS_CA_MAX_ARRAY_BYTES="10000000"
export  PATH="${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:${PATH}"
export  PATH="${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}:${PATH}"

export  LD_LIBRARY_PATH="${EPICS_BASE}/lib/${EPICS_HOST_ARCH}:${LD_LIBRARY_PATH}"

alias cdb="cd ${EPICS_BASE}"
alias cde="cd ${EPICS_EXTENSIONS}"
alias cdi="cd ${HOME}/epics/${EPICS_VERSION}/ioc"
alias cdm="cd ${HOME}/epics/${EPICS_VERSION}/modules"
alias cded="cd ${HOME}/epics/downloads"

# export EPICS_CA_AUTO_ADDR_LIST=NO
# export EPICS_CA_ADDR_LIST='172.19.64.78'
