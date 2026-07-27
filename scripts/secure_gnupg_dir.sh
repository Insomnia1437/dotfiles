#!/bin/bash

set -eu

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <install-home>" >&2
    exit 2
fi

gnupg_dir="$1/.gnupg"
mkdir -p "$gnupg_dir"
chmod 700 "$gnupg_dir"
