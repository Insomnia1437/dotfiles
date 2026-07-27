#!/bin/bash

set -eu

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <install-home>" >&2
    exit 2
fi

install_home="$1"
ssh_dir="${install_home}/.ssh"
defaults="${ssh_dir}/config.defaults"
local_config="${ssh_dir}/config.local"
config="${ssh_dir}/config"

umask 077
mkdir -p "$ssh_dir"
chmod 700 "$ssh_dir"
touch "$local_config"

if [ ! -f "$defaults" ]; then
    echo "Managed SSH defaults not found: $defaults" >&2
    exit 1
fi

temporary_config=$(mktemp "${ssh_dir}/config.XXXXXX")
trap 'rm -f "$temporary_config"' EXIT

{
    if [ -s "$local_config" ]; then
        printf '%s\n' '# Local machine/account settings'
        sed -n 'p' "$local_config"
        printf '\n'
    fi
    printf '%s\n' '# Managed defaults'
    sed -n 'p' "$defaults"
} > "$temporary_config"

chmod 600 "$temporary_config"
mv "$temporary_config" "$config"
trap - EXIT
