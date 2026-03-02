#!/bin/bash

LOCAL_DIR="${HOME}/local"
BIN_DIR="${LOCAL_DIR}/bin"
JDK_VER="23.0.2"
JDK_DIR="${LOCAL_DIR}/jdk-${JDK_VER}"
PHOEBUS_VER="5.0.2"
PHOEBUS_DIR="${LOCAL_DIR}/phoebus-${PHOEBUS_VER}"

mkdir -p "$BIN_DIR"
mkdir -p "$PHOEBUS_DIR"

if [ ! -d "$JDK_DIR" ]; then
    echo "Downloading and installing OpenJDK 23.0.2..."
    # if [ "$(uname -m)" = "x86_64" ]; then
    #     ARCH="x64"
    # elif [ "$(uname -m)" = "aarch64" ]; then
    #     ARCH="aarch64"
    # else
    #     echo "Unsupported architecture: $(uname -m)"
    #     exit 1
    # fi
    # wget https://download.java.net/java/GA/jdk23.0.2/6da2a6609d6e406f85c491fcb119101b/7/GPL/openjdk-23.0.2_linux-${ARCH}_bin.tar.gz -O /tmp/jdk23.tar.gz
    wget https://download.java.net/java/GA/jdk23.0.2/6da2a6609d6e406f85c491fcb119101b/7/GPL/openjdk-23.0.2_linux-x64_bin.tar.gz -O /tmp/jdk23.tar.gz
    mkdir -p "$JDK_DIR"
    tar -xzf /tmp/jdk23.tar.gz -C "$JDK_DIR" --strip-components=1
    rm /tmp/jdk23.tar.gz
else
    echo "OpenJDK 23.0.2 is already installed."
fi

if [ -d "${PHOEBUS_DIR}/product-${PHOEBUS_VER}.jar" ]; then
    echo "Phoebus ${PHOEBUS_VER} is already installed."
    exit 0
fi

wget https://github.com/ControlSystemStudio/phoebus/releases/download/v${PHOEBUS_VER}/phoebus-${PHOEBUS_VER}-linux.tar.gz -O /tmp/phoebus.tar.gz
tar -xzf /tmp/phoebus.tar.gz -C "$PHOEBUS_DIR" --strip-components=1
rm /tmp/phoebus.tar.gz

cat <<EOF > "${BIN_DIR}/phoebus-${PHOEBUS_VER}"
#!/bin/bash
export JAVA_HOME=${JDK_DIR}
export PATH="\${JAVA_HOME}/bin:\${PATH}"
bash ${PHOEBUS_DIR}/phoebus.sh > /dev/null 2>&1 &

EOF

chmod u+x "${BIN_DIR}/phoebus-${PHOEBUS_VER}.sh"
echo "Phoebus ${PHOEBUS_VER} has been installed. You can run it using ${BIN_DIR}/phoebus-${PHOEBUS_VER}.sh"
