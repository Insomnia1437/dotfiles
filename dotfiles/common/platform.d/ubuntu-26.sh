if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
    alias bat="batcat"
fi
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    alias fd="fdfind"
fi

if command -v wl-copy >/dev/null 2>&1; then
    alias p="pwd | tr -d '\n' | wl-copy"
elif command -v xclip >/dev/null 2>&1; then
    alias p="pwd | tr -d '\n' | xclip -selection clipboard"
fi
