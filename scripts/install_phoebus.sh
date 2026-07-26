#!/bin/bash

set -eu

LOCAL_DIR="${HOME}/local"
BIN_DIR="${LOCAL_DIR}/bin"
JDK_VER="23.0.2"
JDK_DIR="${LOCAL_DIR}/jdk-${JDK_VER}"
PHOEBUS_VER="5.0.5"
PHOEBUS_DIR="${LOCAL_DIR}/phoebus-${PHOEBUS_VER}"
PHOEBUS_BIN="${BIN_DIR}/phoebus-${PHOEBUS_VER}"
OPENJDK_BUILD="6da2a6609d6e406f85c491fcb119101b/7/GPL"

if [ "$(uname -s)" != "Linux" ]; then
    echo "This installer currently supports Linux only." >&2
    exit 1
fi

case "$(uname -m)" in
    x86_64|amd64)
        ARCH="x64"
        ;;
    aarch64|arm64)
        ARCH="aarch64"
        ;;
    *)
        echo "Unsupported architecture: $(uname -m)" >&2
        exit 1
        ;;
esac

TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/install-phoebus.XXXXXX")
trap 'rm -rf "$TEMP_DIR"' EXIT
JDK_ARCHIVE="${TEMP_DIR}/jdk.tar.gz"
PHOEBUS_ARCHIVE="${TEMP_DIR}/phoebus.tar.gz"

mkdir -p "$BIN_DIR"
mkdir -p "$PHOEBUS_DIR"

if [ ! -d "$JDK_DIR" ]; then
    echo "Downloading and installing OpenJDK ${JDK_VER} for ${ARCH}..."
    wget "https://download.java.net/java/GA/jdk${JDK_VER}/${OPENJDK_BUILD}/openjdk-${JDK_VER}_linux-${ARCH}_bin.tar.gz" -O "$JDK_ARCHIVE"
    mkdir -p "$JDK_DIR"
    tar -xzf "$JDK_ARCHIVE" -C "$JDK_DIR" --strip-components=1
else
    echo "OpenJDK ${JDK_VER} is already installed."
fi

if [ -f "${PHOEBUS_DIR}/product-${PHOEBUS_VER}.jar" ] && [ -x "$PHOEBUS_BIN" ]; then
    echo "Phoebus ${PHOEBUS_VER} is already installed."
    exit 0
fi

wget "https://github.com/ControlSystemStudio/phoebus/releases/download/v${PHOEBUS_VER}/phoebus-${PHOEBUS_VER}-linux.tar.gz" -O "$PHOEBUS_ARCHIVE"
tar -xzf "$PHOEBUS_ARCHIVE" -C "$PHOEBUS_DIR" --strip-components=1

cat <<EOF > "${PHOEBUS_BIN}"
#!/bin/bash
export JAVA_HOME="${JDK_DIR}"
export PATH="\${JAVA_HOME}/bin:\${PATH}"
bash "${PHOEBUS_DIR}/phoebus.sh" > /dev/null 2>&1 &
EOF

chmod u+x "${PHOEBUS_BIN}"
echo "Phoebus ${PHOEBUS_VER} has been installed. You can run it using ${PHOEBUS_BIN}"
