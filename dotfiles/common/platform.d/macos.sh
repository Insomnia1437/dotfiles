# macOS specific settings, aliases, and environment variables

# GPG pinentry tty binding
export GPG_TTY=$(tty)

# Homebrew environment initialization (Apple Silicon or Intel)
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Disable Homebrew analytics
export HOMEBREW_NO_ANALYTICS=1

# Fix Dotdrop mime type detection on macOS
# See: https://github.com/deadc0de6/dotdrop/blob/master/docs/howto/force-mimetype-to-text.md
export DOTDROP_MIME_TEXT="application/x-wine-extension-ini,application/json,application/xml"

# macOS default ls/df/du are BSD-style and do not take GNU options
alias l="ls -AlhF"
alias ll="ls -lhF"
alias lsd="ls -dlh"
alias dfh="df -h"
alias duh="du -h -d1"

# Terminal fix: when connecting from Alacritty/macOS to remote hosts without modern terminfo
alias ssh="TERM=xterm-256color $(which ssh)"

# If dotdrop was installed natively via Homebrew, prefer brew binary over repo wrapper
if command -v brew >/dev/null 2>&1 && brew list dotdrop >/dev/null 2>&1; then
    unalias dotdrop 2>/dev/null || true
fi

# Finder & Clipboard
alias p="pwd | tr -d '\n' | pbcopy"

# System maintenance & networking
alias cleanup-ds="find . -name '.DS_Store' -type f -ls -delete"
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
