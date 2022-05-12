export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export TERM="xterm-256color"
export LESS="-iMR"
# if command -v nvim &> /dev/null; then
#   alias vi='nvim'
# else
#  alias vi='vim'
# fi
export VISUAL="vim"
export EDITOR="vim"

{%@@ if profile == "server-linac" @@%}
# for git
export PATH="/usr/new/pkg/git/current/bin:${PATH}"
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
export  WIND_HOME='/cont/VxWorks/vw68'
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
{%@@ if profile == "raspi" @@%}
export  EPICS_HOST_ARCH="linux-arm"
{%@@ elif profile == "laptop-macos" @@%}
export  EPICS_HOST_ARCH="darwin-x86"
{%@@ else @@%}
export  EPICS_HOST_ARCH="linux-x86_64"
{%@@ endif @@%}

alias epics314128="source ~/.config/common/epics.sh R3.14.12.8"
alias epics314121="source ~/.config/common/epics.sh R3.14.12.1"
alias epics3155="source ~/.config/common/epics.sh R3.15.5"

# alias epics7="source ~/.config/common/epics.sh R7.0.3"