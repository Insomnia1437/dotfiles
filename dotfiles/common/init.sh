# prevent from duplicated loading
if [ -z "$_INIT_SH_LOADED" ]; then
    _INIT_SH_LOADED=1
else
    return
fi
# if not running interactively
case $- in
    *i*) ;;
    *) return;;
esac

# both for bash and zsh
source ~/.config/common/alias.sh
source ~/.config/common/export.sh
source ~/.config/common/proxy.sh
source ~/.config/common/epics.sh
# pyenv should be the last
{%@@ if USE_PYENV == "YES" @@%}
source ~/.config/common/pyenv.sh
{%@@ endif @@%}

# for some temperary config like
# export EPICS_CA_AUTO_ADDR_LIST=NO
# export EPICS_CA_ADDR_LIST='172.19.64.78'
# export EPICS_PVA_AUTO_ADDR_LIST=NO
# export EPICS_PVA_ADDR_LIST='172.19.64.78'

# this file is not managed by dotdrop and git
if [ -f ~/.config/common/local.sh ]; then
    source ~/.config/common/local.sh
fi

# remove duplicated path
if [ -n "$PATH" ]; then
    old_PATH=$PATH:; PATH=
    while [ -n "$old_PATH" ]; do
        x=${old_PATH%%:*}
        case $PATH: in
           *:"$x":*) ;;
           *) PATH=$PATH:$x;;
        esac
        old_PATH=${old_PATH#*:}
    done
    PATH=${PATH#:}
    unset old_PATH x
fi

