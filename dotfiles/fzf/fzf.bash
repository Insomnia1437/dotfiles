if [ -f ~/.fzf/bin/fzf ]; then
    PATH="${PATH:+${PATH}:}${HOME}/.fzf/bin"
    eval "$(fzf --bash)"

    __global_history_search() {
        local selected
        selected=$(cat ~/.bash_history.* 2>/dev/null | tac | \
            awk '!seen[$0]++' | \
            fzf --height 40% --reverse --prompt="Global History> ") || return
        READLINE_LINE="$selected"
        READLINE_POINT=${#READLINE_LINE}
    }
    bind -x '"\C-r": __global_history_search'
fi
