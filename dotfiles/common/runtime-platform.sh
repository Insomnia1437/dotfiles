# Detect the platform at shell startup. This must remain runtime logic because
# the Linac NFS home is shared by hosts running different Linux releases.
DOTFILES_OS_FAMILY="unknown"
DOTFILES_DISTRO_ID="unknown"
DOTFILES_DISTRO_MAJOR="unknown"
DOTFILES_PLATFORM_GROUP="unknown"
DOTFILES_SITE="{{@@ SITE @@}}"

case "$(uname -s 2>/dev/null)" in
    Darwin)
        DOTFILES_OS_FAMILY="macos"
        DOTFILES_DISTRO_ID="macos"
        DOTFILES_PLATFORM_GROUP="macos"
        ;;
    Linux)
        DOTFILES_OS_FAMILY="linux"
        if [ -r /etc/os-release ]; then
            DOTFILES_DISTRO_ID=$(
                . /etc/os-release
                printf '%s' "${ID:-unknown}"
            )
            DOTFILES_DISTRO_MAJOR=$(
                . /etc/os-release
                printf '%s' "${VERSION_ID%%.*}"
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
            ubuntu)
                DOTFILES_PLATFORM_GROUP="ubuntu-${DOTFILES_DISTRO_MAJOR}"
                ;;
            debian)
                DOTFILES_PLATFORM_GROUP="debian-${DOTFILES_DISTRO_MAJOR}"
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

export DOTFILES_OS_FAMILY
export DOTFILES_DISTRO_ID
export DOTFILES_DISTRO_MAJOR
export DOTFILES_PLATFORM_GROUP
export DOTFILES_SITE
