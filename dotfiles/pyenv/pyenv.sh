# define pyenv if necessary
export PYENV_ROOT="${HOME}/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="${PYENV_ROOT}/bin:${PATH}"
if command -v pyenv 1>/dev/null 2>&1; then
    # https://github.com/pyenv/pyenv/issues/1906
    # eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi
# might cause shell be slow !
# eval "$(pyenv virtualenv-init -)"