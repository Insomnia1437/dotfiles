FZF_DEFAULT_COMMAND="fd --type f \
  --strip-cwd-prefix \
  --exclude .git \
  --exclude node_modules \
  --exclude target \
  --exclude dist \
  --exclude build \
  --max-depth 5"
  # --follow \

FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border
  --info=inline"

# for zsh, history search is managed by zsh-fzf-history-search plugin
FZF_CTRL_R_OPTS="
  +s +m -x -e
  --prompt='Search> '
  --color header:italic
  --header 'Search through command history with fzf.'"
  # --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'

FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
FZF_CTRL_T_OPTS="
  --preview 'command -v bat >/dev/null && bat --theme=GitHub --style=numbers --color=always --line-range :500 {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
"
  # --walker-skip .git,node_modules,target,dist,build


FZF_ALT_C_COMMAND="fd --type d --hidden --follow \
  --exclude .git \
  --exclude node_modules \
  --max-depth 5"

FZF_ALT_C_OPTS="
  --preview 'command -v tree >/dev/null && tree -C {} | head -200'
"
