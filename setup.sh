#!/usr/bin/env sh
set -eu

BASE_URL="${REFORGE_APT_BASE_URL:-https://reforge-robotics.github.io/reforge-core-cpp}"
SUITE="${REFORGE_APT_SUITE:-stable}"
COMPONENT="${REFORGE_APT_COMPONENT:-main}"
KEYRING="/usr/share/keyrings/reforge-archive-keyring.gpg"
SOURCE_LIST="/etc/apt/sources.list.d/reforge.list"
SUPPORTED_OS_ID="ubuntu"
SUPPORTED_VERSION_ID="24.04"
SUPPORTED_CODENAME="noble"

if [ "$(id -u)" -ne 0 ]; then
    echo "setup.sh must run as root." >&2
    exit 1
fi

if [ ! -r /etc/os-release ]; then
    echo "setup.sh requires Ubuntu 24.04 (noble); /etc/os-release is missing." >&2
    exit 1
fi

. /etc/os-release
OS_ID="${ID:-}"
OS_VERSION_ID="${VERSION_ID:-}"
OS_CODENAME="${VERSION_CODENAME:-}"
OS_PRETTY_NAME="${PRETTY_NAME:-unknown Linux distribution}"

if [ "${OS_ID}" != "${SUPPORTED_OS_ID}" ] || [ "${OS_VERSION_ID}" != "${SUPPORTED_VERSION_ID}" ]; then
    echo "Reforge APT packages currently support only Ubuntu 24.04 (noble). Detected: ${OS_PRETTY_NAME}." >&2
    exit 1
fi

if [ -n "${OS_CODENAME}" ] && [ "${OS_CODENAME}" != "${SUPPORTED_CODENAME}" ]; then
    echo "Reforge APT packages currently support only Ubuntu 24.04 (noble). Detected codename: ${OS_CODENAME}." >&2
    exit 1
fi

ARCHITECTURE="$(dpkg --print-architecture)"

install -d -m 0755 /usr/share/keyrings /etc/apt/sources.list.d

if command -v curl >/dev/null 2>&1; then
    curl -fsSL "${BASE_URL}/reforge-archive-keyring.gpg" -o "${KEYRING}"
elif command -v wget >/dev/null 2>&1; then
    wget -qO "${KEYRING}" "${BASE_URL}/reforge-archive-keyring.gpg"
else
    echo "setup.sh requires curl or wget to fetch the Reforge keyring." >&2
    exit 1
fi

chmod 0644 "${KEYRING}"
printf 'deb [arch=%s signed-by=%s] %s %s %s\n' \
    "${ARCHITECTURE}" "${KEYRING}" "${BASE_URL}" "${SUITE}" \
    "${COMPONENT}" > "${SOURCE_LIST}"

echo "Configured Reforge APT repository: ${BASE_URL} ${SUITE} ${COMPONENT}"
echo "Next commands:"
echo "  sudo apt update"
echo "  sudo apt install reforge-core-shaper"
echo "  sudo apt install reforge-core"
