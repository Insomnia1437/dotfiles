alias   rm="rm -i"
alias   cp="cp -i"
alias   mv="mv -i"
alias   grep="grep --color"
alias   vi="vim"
{%@@ if profile == "laptop-macos" @@%}
alias   l="ls -AlhF"
alias   lsd="ls -dlh"
{%@@ else @@%}
alias   l="ls -AlhF --color=auto"
alias   lsd="ls -dlh --color=auto"
{%@@ endif @@%}
alias   type="type -a"
alias   cd..="cd .."
alias   cd~="cd ~"
alias   ..="cd .."
alias   ...="cd ../.."
alias   ..2="cd ../.."
alias   ..3="cd ../../.."
alias   lsg="ls -lhFa | grep"
alias   duh="du -h --max-depth=1"
#alias  duhome='du -h --max-depth=1 --exclude "./.*"'
alias   dfh="df -Th"
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
{%@@ if profile == "server-linac" @@%}
# for sad
alias   sad="/usr/new/pkg/SAD/bin/gs"
{%@@ endif @@%}