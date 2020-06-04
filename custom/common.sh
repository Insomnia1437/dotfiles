# set git in linac server
# setenv PATH /usr/new/pkg/git/current/bin:$PATH

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export TERM="xterm-256color"

export VISUAL=vim
export EDITOR=vim

# add node and npm to path
export PATH=/usr/new/pkg/node/11.7.0_c6_x64/bin/:$PATH

# https://superuser.com/questions/1195962/cannot-make-directory-var-run-screen-permission-denied
if [[ ! -e /var/run/screen && ! -e /run/screen && ! -d ~/.screen ]];then
    mkdir ~/.screen
    chmod 700 ~/.screen
    export SCREENDIR=~/.screen
fi
