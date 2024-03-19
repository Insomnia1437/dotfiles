#!/bin/bash
# Sometimes the remote branch may modify its commit history (perhaps used rebase) and it diverges with local.
# Set git depth to 5 so that I can reset the history and manually merge
# Old git version may get error
# fatal: git fetch-pack: expected shallow list
# So we need to set depth to 0 sometimes
GIT_DEPTH=$1
if [ ! -d "$3" ]; then
#   git clone --recurse-submodules --depth=1 "$2" "$3"
  git clone --depth=$GIT_DEPTH "$2" "$3"
else
  cd "$3" && git pull --ff-only --depth=$GIT_DEPTH
fi