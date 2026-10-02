if [ -d /usr/local/sbin ]; then
    PATH="/usr/local/sbin:${PATH}"
fi
if [ -d /usr/sbin ]; then
    PATH="/usr/sbin:${PATH}"
fi

if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
    alias bat="batcat"
fi
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    alias fd="fdfind"
fi
