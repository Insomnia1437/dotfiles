alias pacs="sudo pacman -S"
alias pacu="sudo pacman -Syu"
alias pacq="pacman -Qs"

alias pac-clean="sudo pacman -Rns \$(pacman -Qtdq) 2>/dev/null || echo 'No orphan packages found.'"
