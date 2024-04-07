#!/bin/bash
# Sometimes the remote branch may modify its commit history (perhaps used rebase) and it diverges with local.
# Set git depth to 5 so that I can reset the history and manually merge
# Old git version may get error
# fatal: git fetch-pack: expected shallow list
# So we need to disable shallow clone depth to 0 sometimes
if [ $1 == "0" ];then
  GIT_DEPTH_OPTION=""
else
  GIT_DEPTH_OPTION="--depth=$1"
fi

if [ ! -d "$3" ]; then
#   git clone --recurse-submodules --depth=1 "$2" "$3"
  git clone $GIT_DEPTH_OPTION "$2" "$3"
else
  cd "$3" && git pull --ff-only $GIT_DEPTH_OPTION
fi