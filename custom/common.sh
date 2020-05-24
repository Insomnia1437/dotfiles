# set git in linac server
# setenv PATH /usr/new/pkg/git/current/bin:$PATH

export LANG=en_US.UTF-8
# export LC_ALL=en_US.UTF-8
export TERM="xterm-256color"

export VISUAL=vim
export EDITOR=vim

# add node and npm to path
export PATH=/usr/new/pkg/node/current_x64/bin/:$PATH

# https://superuser.com/questions/1195962/cannot-make-directory-var-run-screen-permission-denied
if [[ ! -e /var/run/screen && ! -e /run/screen && ! -d ~/.screen ]];then
    mkdir ~/.screen
    chmod 700 ~/.screen
    export SCREENDIR=~/.screen
fi

# set ssh Server
# alias   vera='ssh -X sdcswd@vera'
# alias   ganeza='ssh -X sdcswd@ganeza'
# alias   ganapati='ssh -X sdcswd@ganapati'
# alias   wang='ssh -X sdcswd@wang'
# alias   abcob06='ssh -X sdcswd@abcob06'
# alias   abco7='ssh sdcswd@abco7'

# for elasticsearch
# export ES_HEAP_SIZE=6g