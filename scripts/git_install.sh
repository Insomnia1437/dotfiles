#!/bin/bash
# Sometimes the remote branch may modify its commit history (perhaps used rebase) and it diverges with local.
# Set git depth to 5 so that I can reset the history and manually merge
# Old git version may get error
# fatal: git fetch-pack: expected shallow list
# So we need to disable shallow clone depth to 0 sometimes
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
  git -C "$3" pull --ff-only "${GIT_DEPTH_OPTIONS[@]}"
else
  echo "Destination exists but is not a Git repository: $3" >&2
  exit 1
fi
