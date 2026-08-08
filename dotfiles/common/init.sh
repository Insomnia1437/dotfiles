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

# Detect the current host at runtime. This is important on the Linac NFS home,
# where the same dotfiles are sourced by multiple Linux releases.
source ~/.config/common/runtime-platform.sh

# both for bash and zsh
source ~/.config/common/alias.sh
source ~/.config/common/export.sh
source ~/.config/common/proxy.sh

platform_config="${HOME}/.config/common/platform.d/${DOTFILES_PLATFORM_GROUP}.sh"
if [ -r "$platform_config" ]; then
    source "$platform_config"
fi
unset platform_config

site_config="${HOME}/.config/common/site.d/${DOTFILES_SITE}.sh"
if [ -r "$site_config" ]; then
    source "$site_config"
fi
unset site_config

if [ -f ~/.fzf.sh ]; then
    source ~/.fzf.sh
fi

if [ -n "${FZF_BIN:-}" ]; then
    if [ -n "${BASH_VERSION:-}" ]; then
        eval "$($FZF_BIN --bash)"
    elif [ -n "${ZSH_VERSION:-}" ]; then
        source <($FZF_BIN --zsh)
    fi
fi


# enable epics env in local.sh, this gives me choice to use other epics
# e.g., echo "epics708" >> ~/.config/common/epics.sh
# source ~/.config/common/epics.sh
# pyenv should be the last
{%@@ if USE_PYENV == "YES" @@%}
source ~/.pyenv.sh
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
