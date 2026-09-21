# Linac-wide settings shared across hosts and Linux releases.

# Prefer capability and path detection over distribution-name checks.
use_pkg_tmux=1
if [ -x /usr/bin/tmux ]; then
    tmux_ver=$(/usr/bin/tmux -V 2>/dev/null | awk '{print $2}')
    if [ -n "$tmux_ver" ]; then
        if [ "$(printf '3.1\n%s\n' "$tmux_ver" | sort -V | head -n 1)" = "3.1" ] && [ "$tmux_ver" != "3.1" ]; then
            use_pkg_tmux=0
        fi
    fi
fi

for dotfiles_path in \
    "${HOME}/.cargo/bin" \
    "/usr/new/pkg/node/11.7.0_c6_x64/bin"
do
    if [ -d "$dotfiles_path" ]; then
        PATH="${dotfiles_path}:${PATH}"
    fi
done

if [ "$use_pkg_tmux" = "1" ] && [ -d /usr/new/pkg/tmux/3.1b_x64/bin ]; then
    PATH="/usr/new/pkg/tmux/3.1b_x64/bin:${PATH}"
fi
export PATH
unset dotfiles_path

if [ "$use_pkg_tmux" = "1" ] && [ -d /usr/new/pkg/libevent/2.1.12_x64/lib ]; then
    if [ -n "${LD_LIBRARY_PATH:-}" ]; then
        LD_LIBRARY_PATH="/usr/new/pkg/libevent/2.1.12_x64/lib:${LD_LIBRARY_PATH}"
    else
        LD_LIBRARY_PATH="/usr/new/pkg/libevent/2.1.12_x64/lib"
    fi
    export LD_LIBRARY_PATH
fi
unset use_pkg_tmux tmux_ver

if [ -d /cont/VxWorks/vw69 ]; then
    export WIND_HOME="/cont/VxWorks/vw69"
fi

if [ -x /usr/new/pkg/SAD/bin/gs ]; then
    alias sad="/usr/new/pkg/SAD/bin/gs"
fi
