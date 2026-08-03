export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
# it is meant to be used only for testing or troubleshooting purposes
# export LC_ALL="en_US.UTF-8"

if [[ -z ${TERM} ]]; then
    export TERM="xterm-256color"
fi
export LESS="-iMR"
# fedora enables it in /etc/profile.d/less.sh
export LESSOPEN=""
# if command -v nvim &> /dev/null; then
#   alias vi='nvim'
# else
#  alias vi='vim'
# fi
export VISUAL="vim"
export EDITOR="vim"
# for program installed by pip install --user
export PATH="{{@@ HOME @@}}/.local/bin:${PATH}"
# for manually installed program
export PATH="{{@@ HOME @@}}/local/bin:${PATH}"

export UNAME_R=$(uname -r)

{%@@ if OS_FAMILY == "macos" @@%}
# for GPG TTY
export GPG_TTY=$(tty)

# for MacPorts
# export PATH="/opt/local/bin:/opt/local/sbin:${PATH}"
# Apple Silicon
# export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"
# Intel
# export PATH="/usr/local/bin:/usr/local/sbin:${PATH}"
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi
                                                                                            
# see https://github.com/deadc0de6/dotdrop/blob/35fac6caf13655e9ff2bcfbc89d75adf98405249/docs/howto/force-mimetype-to-text.md
export DOTDROP_MIME_TEXT="application/x-wine-extension-ini,application/json,application/xml"
{%@@ endif @@%}

# for EPICS HOST ARCH
export EPICS_HOST_ARCH={{@@ EPICS_HOST_ARCH @@}}

alias epics314128="source ~/.config/common/epics.sh R3.14.12.8"
# alias epics314121="source ~/.config/common/epics.sh R3.14.12.1"
alias epics3155="source ~/.config/common/epics.sh R3.15.5"
alias epics3159="source ~/.config/common/epics.sh R3.15.9"

# alias epics707="source ~/.config/common/epics.sh R7.0.7"
alias epics708="source ~/.config/common/epics.sh R7.0.8"
alias epics709="source ~/.config/common/epics.sh R7.0.9"
alias epics7010="source ~/.config/common/epics.sh R7.0.10"
