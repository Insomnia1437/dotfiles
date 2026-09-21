# Detect the platform at shell startup. This must remain runtime logic because
# the Linac NFS home is shared by hosts running different Linux releases.
DOTFILES_OS_FAMILY="unknown"
DOTFILES_DISTRO_ID="unknown"
DOTFILES_DISTRO_MAJOR="unknown"
DOTFILES_PLATFORM_GROUP="unknown"

case "$(uname -s 2>/dev/null)" in
    Darwin)
        DOTFILES_OS_FAMILY="macos"
        DOTFILES_DISTRO_ID="macos"
        raw_major=$(sw_vers -productVersion 2>/dev/null | cut -d. -f1)
        DOTFILES_DISTRO_MAJOR="${raw_major:-unknown}"
        unset raw_major
        DOTFILES_PLATFORM_GROUP="macos"
        ;;
    Linux)
        DOTFILES_OS_FAMILY="linux"
        if [ -r /etc/os-release ]; then
            DOTFILES_DISTRO_ID=$(
                . /etc/os-release
                printf '%s' "${ID:-unknown}" | tr '[:upper:]' '[:lower:]' | tr -d '"'\'' '
            )
            DOTFILES_DISTRO_MAJOR=$(
                . /etc/os-release
                raw_ver="${VERSION_ID:-unknown}"
                raw_ver="${raw_ver%%.*}"
                printf '%s' "$raw_ver" | tr -d '"'\'' '
            )
        elif [ -r /etc/redhat-release ]; then
            DOTFILES_DISTRO_ID="rhel"
            DOTFILES_DISTRO_MAJOR=$(
                sed -n 's/.*release \([0-9][0-9]*\).*/\1/p' /etc/redhat-release
            )
        fi

        case "$DOTFILES_DISTRO_ID" in
            rhel|centos|rocky|almalinux)
                DOTFILES_PLATFORM_GROUP="rhel-${DOTFILES_DISTRO_MAJOR}"
                ;;
            fedora)
                DOTFILES_PLATFORM_GROUP="fedora"
                ;;
            ubuntu)
                DOTFILES_PLATFORM_GROUP="ubuntu-${DOTFILES_DISTRO_MAJOR}"
                ;;
            debian)
                DOTFILES_PLATFORM_GROUP="debian-${DOTFILES_DISTRO_MAJOR}"
                ;;
            arch|manjaro)
                DOTFILES_PLATFORM_GROUP="arch"
                ;;
            raspbian)
                DOTFILES_PLATFORM_GROUP="raspios"
                ;;
            *)
                DOTFILES_PLATFORM_GROUP="${DOTFILES_DISTRO_ID}-${DOTFILES_DISTRO_MAJOR}"
                ;;
        esac
        ;;
esac

# Honor install-time platform override if present (e.g. raspios)
if [ -n "${DOTFILES_PLATFORM_OVERRIDE:-}" ]; then
    DOTFILES_PLATFORM_GROUP="$DOTFILES_PLATFORM_OVERRIDE"
fi

export DOTFILES_OS_FAMILY
export DOTFILES_DISTRO_ID
export DOTFILES_DISTRO_MAJOR
export DOTFILES_PLATFORM_GROUP
