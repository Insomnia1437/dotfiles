# Linac-wide settings shared across hosts and Linux releases.

# Prefer capability and path detection over distribution-name checks.
for dotfiles_path in \
    "${HOME}/.cargo/bin" \
    "/usr/new/pkg/node/11.7.0_c6_x64/bin" \
    "/usr/new/pkg/tmux/3.1b_x64/bin"
do
    if [ -d "$dotfiles_path" ]; then
        PATH="${dotfiles_path}:${PATH}"
    fi
done
export PATH
unset dotfiles_path

if [ -d /usr/new/pkg/libevent/2.1.12_x64/lib ]; then
    if [ -n "${LD_LIBRARY_PATH:-}" ]; then
        LD_LIBRARY_PATH="/usr/new/pkg/libevent/2.1.12_x64/lib:${LD_LIBRARY_PATH}"
    else
        LD_LIBRARY_PATH="/usr/new/pkg/libevent/2.1.12_x64/lib"
    fi
    export LD_LIBRARY_PATH
fi

if [ -d /cont/VxWorks/vw69 ]; then
    export WIND_HOME="/cont/VxWorks/vw69"
fi

if [ -x /usr/new/pkg/SAD/bin/gs ]; then
    alias sad="/usr/new/pkg/SAD/bin/gs"
fi
