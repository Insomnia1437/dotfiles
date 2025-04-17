export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
# it is meant to be used only for testing or troubleshooting purposes
# export LC_ALL="en_US.UTF-8"

if [[ -z ${TERM} ]]; then
    export TERM="xterm-256color"
fi
export LESS="-iMR"
# if command -v nvim &> /dev/null; then
#   alias vi='nvim'
# else
#  alias vi='vim'
# fi
export VISUAL="vim"
export EDITOR="vim"
# {%@@ if profile == "wsl" @@%}
export  PATH="{{@@ HOME @@}}/.local/bin:${PATH}"
# {%@@ endif @@%}

{%@@ if profile == "server-linac" @@%}
# for cargo
export PATH="${HOME}/.cargo/bin:${PATH}"

# for git
# export PATH="/usr/new/pkg/git/current/bin:${PATH}"
# add node and npm to path
export PATH="/usr/new/pkg/node/11.7.0_c6_x64/bin/:${PATH}"
# for tmux
export PATH="/usr/new/pkg/tmux/3.1b_x64/bin/:${PATH}"
# tmux requires libevent 2.x
if [[ -z ${LD_LIBRARY_PATH} ]]; then
    export LD_LIBRARY_PATH="/usr/new/pkg/libevent/2.1.12_x64/lib"
else
    export LD_LIBRARY_PATH="/usr/new/pkg/libevent/2.1.12_x64/lib/:${LD_LIBRARY_PATH}"
fi

# for vxworks
# export  WIND_HOME='/cont/VxWorks/vw68'
# export  WIND_HOME='/usr/users/control/VxWorks/vw683'
export  WIND_HOME='/cont/VxWorks/vw69'
# for tmux
# https://github.com/tmux/tmux/issues/2771

# for screen
# socket directory is /var/run/screen at linac
# https://superuser.com/questions/1195962/cannot-make-directory-var-run-screen-permission-denied
# this may cause some problem since the socket file for screen is shared for many servers
# if [[ ! -e /var/run/screen && ! -e /run/screen && ! -d ~/.screen ]];then
    # mkdir ~/.screen
    # chmod 700 ~/.screen
    # export SCREENDIR=~/.screen
# fi
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

# if [[ $(hostname) != *"mtca"* ]]; then
#   epics709
# else
#   source ~/.config/common/epics.sh "R7.0.8.1" "/usr/users/control/epics/vadatech"
# fi
