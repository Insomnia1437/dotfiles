alias   rm="rm -i"
alias   cp="cp -i"
alias   mv="mv -i"
alias   grep="grep --color"
alias   vi="vim"
{%@@ if os == "darwin" @@%}
alias   l="ls -AlhF"
alias   ll="ls -lhF"
alias   lsd="ls -dlh"
alias   dfh="df -h"
alias   duh="du -h -d1"
# https://github.com/alacritty/alacritty/issues/3962
# when connecting to a server where terminfo is limited, force using xterm-256color
alias ssh="TERM=xterm-256color $(which ssh)"
{%@@ else @@%}
alias   l="ls -AlhF --color=auto"
alias   ll="ls -lhF --color=auto"
alias   llt="ls -lhF --color=auto --time-style=long-iso"
alias   lsd="ls -dlh --color=auto"
alias   dfh="df -Th"
alias   duh="du -h --max-depth=1"
{%@@ endif @@%}
alias   type="type -a"
alias   cd..="cd .."
alias   cd~="cd ~"
alias   cd-="cd -"
alias   ..="cd .."
alias   ...="cd ../.."
alias   ..2="cd ../.."
alias   ..3="cd ../../.."
alias   lsg="ls -lhFa | grep"
#alias  duhome='du -h --max-depth=1 --exclude "./.*"'
alias   freeh="free -h"
alias   psg="ps axuww | grep -v grep | grep"
alias   psgl="ps axlww | grep -v grep | grep"
alias   ff="find . -type f -name"
alias   fd="find . -type d -name"
alias   cdw="cd ${HOME}/workspace"
# follow the XDG standards, https://wiki.archlinux.org/title/XDG_user_directories
alias   cdd="cd ${HOME}/Downloads"
alias   q="exit"
alias   dotdrop="${HOME}/.config/dotfiles/dotdrop.sh"
alias   grepconf='grep "^[^#]"'
alias   histg="history | grep"
alias   histl="history | less"
alias   path='echo -e ${PATH//:/\\n}'
{%@@ if profile == "server-linac" @@%}
# for sad
alias   sad="/usr/new/pkg/SAD/bin/gs"
{%@@ endif @@%}
