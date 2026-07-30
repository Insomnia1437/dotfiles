#!/bin/bash
# Clone external dependencies when they are missing. Existing repositories are
# intentionally left untouched so a dotfiles install never performs an implicit
# upgrade or fails because an upstream branch rewrote its history.
set -e

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <depth|0> <repository-url> <destination>" >&2
  exit 2
fi

case "$1" in
  0)
    GIT_DEPTH_OPTIONS=()
    ;;
  *[!0-9]*|'')
    echo "Invalid git depth: $1" >&2
    exit 2
    ;;
  *)
    GIT_DEPTH_OPTIONS=("--depth=$1")
    ;;
esac

if [ ! -e "$3" ]; then
  git clone "${GIT_DEPTH_OPTIONS[@]}" "$2" "$3"
elif [ -d "$3/.git" ]; then
  printf 'Repository already exists, skipping update: %s\n' "$3"
else
  echo "Destination exists but is not a Git repository: $3" >&2
  exit 1
fi
