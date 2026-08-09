# Set FZF_ENABLED=NO in platform.d/<platform>.sh to disable fzf.
if [ "${FZF_ENABLED:-YES}" != "YES" ]; then
  return
fi
if [ -n "${_FZF_CONFIG_LOADED:-}" ]; then
  return
fi
_FZF_CONFIG_LOADED=1

# Always use the self-contained fzf installation in the home directory.  Do
# not silently fall back to a package-manager version with different features.
FZF_HOME="${HOME}/.fzf"
FZF_BIN="${FZF_HOME}/bin/fzf"
if [ ! -x "${FZF_BIN}" ]; then
  unset FZF_HOME FZF_BIN
  return
fi
PATH="${FZF_HOME}/bin${PATH:+:${PATH}}"
export PATH FZF_HOME FZF_BIN

# Leave the input commands unset so fzf and its shell integration use the
# built-in walker instead of fd/find.  The same exclusions apply everywhere.
unset FZF_DEFAULT_COMMAND FZF_CTRL_T_COMMAND FZF_ALT_C_COMMAND
FZF_WALKER_SKIP=".git,node_modules,target,dist,build,.cache"

FZF_DEFAULT_OPTS="
  --walker=file,follow,hidden
  --walker-skip=${FZF_WALKER_SKIP}
  --height=70%
  --min-height=20
  --layout=reverse
  --border=rounded
  --info=inline-right
  --cycle
  --scroll-off=3
  --prompt='> '
  --pointer='>'
  --marker='+'"

FZF_CTRL_R_OPTS="
  --prompt='History> '
  --color=header:italic
  --header='CTRL-R: toggle sort'"

# bat is optional.  Debian-family systems commonly expose it as batcat; cat is
# the portable final fallback.  Directories get a dependency-free ls preview.
FZF_CTRL_T_OPTS="
  --walker=file,dir,follow,hidden
  --walker-skip=${FZF_WALKER_SKIP}
  --prompt='Files> '
  --preview-window='right,60%,border-left,wrap,<80(up,50%,border-bottom)'
  --preview 'if [ -f {} ]; then
    if command -v bat >/dev/null 2>&1; then
      bat --theme=GitHub --style=numbers --color=always --line-range=:500 -- {}
    elif command -v batcat >/dev/null 2>&1; then
      batcat --theme=GitHub --style=numbers --color=always --line-range=:500 -- {}
    else
      cat -- {}
    fi
  elif [ -d {} ]; then
    ls -la -- {}
  fi'
  --bind='ctrl-/:toggle-preview'"

FZF_ALT_C_OPTS="
  --walker=dir,follow,hidden
  --walker-skip=${FZF_WALKER_SKIP}
  --prompt='Directories> '
  --preview-window='right,50%,border-left,<80(up,50%,border-bottom)'
  --preview=\"if command -v tree >/dev/null 2>&1; then
    tree -C -L 2 --dirsfirst -I '${FZF_WALKER_SKIP//,/|}' -- {}
  else
    ls -la -- {}
  fi\""

export FZF_WALKER_SKIP FZF_DEFAULT_OPTS FZF_CTRL_R_OPTS
export FZF_CTRL_T_OPTS FZF_ALT_C_OPTS
