# Set FZF_ENABLED=NO in platform.d/<platform>.sh when fzf is
# unavailable or too old to support the shell integration below.
if [ "${FZF_ENABLED:-YES}" != "YES" ]; then
  return
fi
if [ -n "${_FZF_CONFIG_LOADED:-}" ]; then
  return
fi
_FZF_CONFIG_LOADED=1
# Prefer the system/package-manager fzf. Use ~/.fzf only when no system fzf
# is available.
if ! command -v fzf >/dev/null 2>&1 && [ -x "${HOME}/.fzf/bin/fzf" ]; then
  PATH="${HOME}/.fzf/bin${PATH:+:${PATH}}"
fi
if command -v fzf >/dev/null 2>&1; then
  FZF_BIN="$(command -v fzf)"
  export FZF_BIN
fi

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

FZF_CTRL_R_OPTS="
  +s +m -x -e
  --prompt='Search> '
  --color header:italic"
  # --header 'Search through command history with fzf.'
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

export FZF_DEFAULT_COMMAND FZF_DEFAULT_OPTS
export FZF_CTRL_R_OPTS FZF_CTRL_T_COMMAND FZF_CTRL_T_OPTS
export FZF_ALT_C_COMMAND FZF_ALT_C_OPTS
