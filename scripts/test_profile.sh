#!/bin/bash

set -eu

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <profile>" >&2
    exit 2
fi

profile="$1"
repo_root=$(cd "$(dirname "$0")/.." && pwd)
dotdrop_bin="${DOTDROP_BIN:-$repo_root/dotdrop.sh}"

file_mode() {
    if stat -c '%a' "$1" >/dev/null 2>&1; then
        stat -c '%a' "$1"
    else
        stat -f '%OLp' "$1"
    fi
}

render_output=$(
    "$dotdrop_bin" install -btfn \
        -c "$repo_root/config.yaml" \
        -p "$profile" 2>&1
)
printf '%s\n' "$render_output"

review_dir=$(
    printf '%s\n' "$render_output" |
        sed -n 's/^installed to tmp "\(.*\)"\.$/\1/p'
)
if [ -z "$review_dir" ]; then
    echo "Unable to find Dotdrop review directory." >&2
    exit 1
fi

zshrc=$(find "$review_dir" -name .zshrc -type f -print -quit)
if [ -z "$zshrc" ]; then
    echo "Rendered .zshrc not found under $review_dir." >&2
    exit 1
fi
install_home=$(dirname "$zshrc")

bash_files=()
for candidate in \
    "$install_home/.bashrc" \
    "$install_home/.pyenv.sh" \
    "$install_home"/.config/common/*.sh \
    "$install_home"/.config/common/platform.d/*.sh \
    "$install_home"/.config/common/site.d/*.sh
do
    if [ -f "$candidate" ]; then
        bash_files+=("$candidate")
    fi
done
bash -n "${bash_files[@]}"
zsh -n "$install_home/.zshrc"

if [ -f "$install_home/.tcshrc" ]; then
    tcsh -n "$install_home/.tcshrc" </dev/null
fi

if [ -f "$install_home/.gitconfig" ]; then
    HOME="$install_home" git config --global --list >/dev/null
fi

if [ -f "$install_home/.ssh/config.defaults" ]; then
    bash "$repo_root/scripts/install_ssh_config.sh" "$install_home"
    ssh -G -F "$install_home/.ssh/config" example.invalid >/dev/null
    test "$(file_mode "$install_home/.ssh")" = "700"
    test "$(file_mode "$install_home/.ssh/config")" = "600"
fi

if [ -d "$install_home/.gnupg" ]; then
    bash "$repo_root/scripts/secure_gnupg_dir.sh" "$install_home"
    test "$(file_mode "$install_home/.gnupg")" = "700"
    GNUPGHOME="$install_home/.gnupg" gpgconf --check-options gpg-agent
fi

if [ -f "$install_home/.inputrc" ]; then
    INPUTRC="$install_home/.inputrc" \
        bash --noprofile --norc \
        -c 'set -o emacs; bind -f "$INPUTRC"' >/dev/null 2>&1
fi

if [ -f "$install_home/.vnc/xstartup" ]; then
    sh -n "$install_home/.vnc/xstartup"
    test "$(file_mode "$install_home/.vnc/config")" = "600"
    test "$(file_mode "$install_home/.vnc/xstartup")" = "700"
fi

if [ -f "$install_home/.config/alacritty/alacritty.toml" ]; then
    python3 - "$install_home/.config/alacritty/alacritty.toml" <<'PY'
import sys

try:
    import tomllib
except ModuleNotFoundError:
    import tomli as tomllib

with open(sys.argv[1], "rb") as config:
    tomllib.load(config)
PY
fi

HOME="$install_home" vim -Nu "$install_home/.vimrc" -n -es +'qa!'

if grep -R -E '\{\{@@|\{%@@' "$install_home" >/dev/null 2>&1; then
    echo "Unexpanded Dotdrop template marker found under $install_home." >&2
    exit 1
fi

if [ -n "${GITHUB_OUTPUT:-}" ]; then
    printf 'review_dir=%s\n' "$review_dir" >> "$GITHUB_OUTPUT"
fi

printf 'Profile %s passed in %s\n' "$profile" "$review_dir"
