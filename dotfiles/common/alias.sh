alias   rm="rm -i"
alias   cp="cp -i"
alias   mv="mv -i"
alias   grep="grep --color -In"
alias   vi="vim"
alias   l="ls -AlhF --color=auto"
alias   ll="ls -lhF --color=auto"
alias   llt="ls -lhF --color=auto --time-style=long-iso"
alias   lsd="ls -dlh --color=auto"
alias   dfh="df -Th"
alias   dflh="df -Tlh"
alias   duh="du -h --max-depth=1"
alias   type="type -a"
alias   cd..="cd .."
alias   cd~="cd ~"
alias   cd-="cd -"
alias   ..="cd .."
alias   ...="cd ../.."
alias   ..2="cd ../.."
alias   ..3="cd ../../.."
alias   lsg="ls -lhFa | grep"
# alias  duhome='du -h --max-depth=1 --exclude "./.*"'
alias   freeh="free -h"
# alias   psg="ps axuww | grep -v grep | grep"
# alias   psgl="ps axlww | grep -v grep | grep"
# alias   ff="find . -type f -name"
# alias   fd="find . -type d -name"
alias   cdw="cd ${HOME}/workspace"
# follow the XDG standards, https://wiki.archlinux.org/title/XDG_user_directories
alias   cdd="cd ${HOME}/Downloads"
alias   q="exit"
alias   grepconf='grep "^[^#]"'
alias   histg="history | grep"
alias   histl="history | less"
alias   path='echo -e ${PATH//:/\\n}'

# ps related
alias psd="ps -eo stat,pid,user,wchan:20,comm,args | awk 'NR==1 || \$1 ~ /^D/'"
alias psz="ps -eo stat,pidid,user,comm | awk 'NR==1 || \$1 ~ /^Z/'"
alias pscpu="ps -eo pidid,user,%cpu,%mem,stat,comm --sort=-%cpu | head -n 11"
alias psmem="ps -eo pidid,user,%mem,rss,vsz,comm --sort=-rss | head -n 11"
alias psforest="ps aux --forest"
alias psnew="ps -eo pid,user,lstart,etimes,comm,args --sort=-etimes | head -n 15"
alias psold="ps -eo pid,user,etime,comm,args --sort=-etimes | tail -n +2 | head -n 15"
alias psme="ps -u \$USER -f"

function psu() {
    ps -u "${1:-$USER}" -f
}

function psg() {
    if [ $# -eq 0 ]; then
        echo "Usage: psg <pattern>" >&2
        return 1
    fi

    local cols=${COLUMNS:-$(tput cols 2>/dev/null || echo 120)}

    ps axlww | awk -v pat="$*" -v maxlen="$cols" '
        BEGIN {
            HDR = "\033[1;37;44m";
            HL  = "\033[1;33m";
            DIM = "\033[2m";
            RST = "\033[0m";
            word_pat = "(^|[^a-zA-Z0-9_])" pat "([^a-zA-Z0-9_]|$)"
        }
        NR == 1 {
            printf "%s%-*.*s%s\n", HDR, maxlen, maxlen, $0, RST
            next
        }
        ($0 ~ word_pat || $0 ~ pat) && $0 !~ /awk -v pat=/ {
            line = $0
            gsub(pat, HL pat RST, line)
            print line
        }
    '
}
