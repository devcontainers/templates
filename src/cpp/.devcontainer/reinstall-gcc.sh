#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
#
set -euox pipefail

# Default GCC version
GCC_VERSION="${1:-12.2.0}"

# Set source and installation directories
GCC_SRC_DIR="/usr/local/src/gcc-${GCC_VERSION}"
GCC_INSTALL_DIR="/usr/local/gcc-${GCC_VERSION}"

# Define GPG keys for verification
GCC_KEYS=(
    "B215C1633BCA0477615F1B35A5B3A004745C015A"
    "B3C42148A44E6983B3E4CC0793FA9B1AB75C61B8"
    "90AA470469D3965A87A5DCB494D03953902C9419"
    "80F98B2E0DAB6C8281BDF541A7C8C3B2F71EDF1C"
    "7F74F97C103468EE5D750B583AB00996FC26A641"
    "33C235A34C46AA3FFB293709A328C3A2C3C45C06"
    "D3A93CAD751C2AF4F8C7AD516C35B99309B5FA62"
)
GCC_MIRRORS=(
    "https://ftpmirror.gnu.org/gcc"
    "https://mirrors.kernel.org/gnu/gcc"
    "https://bigsearcher.com/mirrors/gcc/releases"
    "http://www.netgull.com/gcc/releases"
    "https://sourceware.org/pub/gcc/releases"
    "ftp://ftp.gnu.org/gnu/gcc"
)

# Check if input GCC_VERSION is greater than installed GCC version
if command -v gcc &>/dev/null; then
    installed_version=$(gcc -dumpfullversion)
    if [ "$(printf '%s\n' "$installed_version" "$GCC_VERSION" | sort -V | tail -n1)" = "$installed_version" ]; then
        echo "Installed GCC version ($installed_version) is equal or newer than requested version ($GCC_VERSION). Skipping installation."
        exit 0
    fi
fi

# Install required dependencies
sudo apt-get update
sudo apt-get install -y \
    dpkg-dev flex gnupg build-essential wget curl

# Function to fetch GCC source and signature
fetch_gcc() {
    local file="$1"
    for mirror in "${GCC_MIRRORS[@]}"; do
        if curl -fL "${mirror}/gcc-${GCC_VERSION}/${file}" -o "${file}"; then
            return 0
        fi
    done
    echo "Error: Failed to download ${file} from all mirrors" >&2
    exit 1
}

# Download GCC source and signature
fetch_gcc "gcc-${GCC_VERSION}.tar.xz"
fetch_gcc "gcc-${GCC_VERSION}.tar.xz.sig"

# Verify the signature
export GNUPGHOME=$(mktemp -d)
for key in "${GCC_KEYS[@]}"; do
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"
done
gpg --batch --verify "gcc-${GCC_VERSION}.tar.xz.sig" "gcc-${GCC_VERSION}.tar.xz"
rm -rf "$GNUPGHOME"

# Extract GCC source
sudo mkdir -p "${GCC_SRC_DIR}"
sudo tar -xf "gcc-${GCC_VERSION}.tar.xz" -C "${GCC_SRC_DIR}" --strip-components=1
rm "gcc-${GCC_VERSION}.tar.xz" "gcc-${GCC_VERSION}.tar.xz.sig"

# Prepare GCC source
cd "${GCC_SRC_DIR}"
./contrib/download_prerequisites
for f in config.guess config.sub; do
    wget -O "$f" "https://git.savannah.gnu.org/cgit/config.git/plain/$f?id=7d3d27baf8107b630586c962c057e22149653deb"
    find -mindepth 2 -name "$f" -exec cp -v "$f" '{}' ';'
done

# Build and install GCC
build_dir=$(mktemp -d)
cd "$build_dir"
"${GCC_SRC_DIR}/configure" \
    --prefix="${GCC_INSTALL_DIR}" \
    --disable-multilib \
    --enable-languages=c,c++
make -j "$(nproc)"
sudo make install-strip

# Update alternatives to use the new GCC version as the default version.
sudo update-alternatives --install /usr/bin/gcc gcc ${GCC_INSTALL_DIR}/bin/gcc 999
sudo update-alternatives --install /usr/bin/g++ g++ ${GCC_INSTALL_DIR}/bin/g++ 999
sudo update-alternatives --install /usr/bin/gcc-ar gcc-ar ${GCC_INSTALL_DIR}/bin/gcc-ar 999
sudo update-alternatives --install /usr/bin/gcc-nm gcc-nm ${GCC_INSTALL_DIR}/bin/gcc-nm 999
sudo update-alternatives --install /usr/bin/gcc-ranlib gcc-ranlib ${GCC_INSTALL_DIR}/bin/gcc-ranlib 999
sudo update-alternatives --install /usr/bin/gcov gcov ${GCC_INSTALL_DIR}/bin/gcov 999
sudo update-alternatives --install /usr/bin/gcov-dump gcov-dump ${GCC_INSTALL_DIR}/bin/gcov-dump 999
sudo update-alternatives --install /usr/bin/gcov-tool gcov-tool ${GCC_INSTALL_DIR}/bin/gcov-tool 999

# Cleanup
rm -rf "$build_dir" "${GCC_SRC_DIR}"
sudo apt-get clean

# Verify installation
echo "Verifying GCC installation..."
gcc --version
g++ --version
if [ $? -ne 0 ]; then
    echo "GCC installation failed."
    exit 1
fi

echo "GCC ${GCC_VERSION} has been installed successfully in ${GCC_INSTALL_DIR}!"
