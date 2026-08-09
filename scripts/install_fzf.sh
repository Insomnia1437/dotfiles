#!/usr/bin/env bash
# Install a specified fzf release into ~/.fzf.
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <home-directory> <fzf-version>" >&2
  exit 2
fi

fzf_version="$2"
fzf_version="${fzf_version#v}"
case "$fzf_version" in
  ''|*[!0-9.]*|.*|*..*|*.)
    echo "Invalid FZF_VERSION: $fzf_version" >&2
    exit 2
    ;;
esac

fzf_tag="v${fzf_version}"
fzf_dir="${1%/}/.fzf"
fzf_bin="${fzf_dir}/bin/fzf"

if [ -d "${fzf_dir}/.git" ]; then
  current_tag="$(git -C "$fzf_dir" describe --tags --exact-match 2>/dev/null || true)"
  current_version=""
  if [ -x "$fzf_bin" ]; then
    current_version="$("$fzf_bin" --version 2>/dev/null | awk '{print $1}')"
  fi
  if [ "$current_tag" = "$fzf_tag" ] &&
     [ "$current_version" = "$fzf_version" ] &&
     [ ! -L "$fzf_bin" ]; then
    printf 'fzf %s is already installed at %s\n' "$fzf_version" "$fzf_dir"
    exit 0
  fi

  git -C "$fzf_dir" fetch --depth=1 origin "refs/tags/${fzf_tag}:refs/tags/${fzf_tag}"
  git -C "$fzf_dir" checkout --detach "$fzf_tag"
elif [ -e "$fzf_dir" ]; then
  echo "Destination exists but is not a Git repository: $fzf_dir" >&2
  exit 1
else
  git clone --branch "$fzf_tag" --depth=1 https://github.com/junegunn/fzf.git "$fzf_dir"
fi

# The upstream installer normally reuses an fzf found in PATH when its version
# matches. Hide package-manager copies so ~/.fzf/bin/fzf is always a real,
# self-contained binary rather than a symlink to /usr/bin or Homebrew.
if [ -L "$fzf_bin" ]; then
  rm -f "$fzf_bin"
fi
fzf_shim_dir="$(mktemp -d "${TMPDIR:-/tmp}/fzf-install.XXXXXX")"
cleanup_fzf_shim() {
  rm -f "${fzf_shim_dir}/fzf"
  rmdir "$fzf_shim_dir" 2>/dev/null || true
}
trap cleanup_fzf_shim EXIT
printf '#!/bin/sh\nexit 1\n' >"${fzf_shim_dir}/fzf"
chmod 700 "${fzf_shim_dir}/fzf"
PATH="${fzf_shim_dir}:${PATH}" "${fzf_dir}/install" --bin
cleanup_fzf_shim
trap - EXIT

installed_version="$("$fzf_bin" --version 2>/dev/null | awk '{print $1}')"
if [ "$installed_version" != "$fzf_version" ]; then
  echo "Expected fzf $fzf_version, installed $installed_version" >&2
  exit 1
fi
printf 'Installed fzf %s at %s\n' "$fzf_version" "$fzf_bin"
