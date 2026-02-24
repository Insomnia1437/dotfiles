export FZF_DEFAULT_COMMAND='fd --type f \
  --strip-cwd-prefix \
  --follow \
  --exclude .git \
  --exclude node_modules \
  --exclude target \
  --exclude dist \
  --exclude build \
  --max-depth 5'
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --info=inline
'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat --theme=GitHub --style=numbers --color=always --line-range :500 {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"


export FZF_ALT_C_COMMAND='fd --type d --hidden --follow \
  --exclude .git \
  --exclude node_modules \
  --max-depth 5'
export FZF_ALT_C_OPTS='
'