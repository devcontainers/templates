#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
#
set -euo pipefail

# Default GCC version
GCC_VERSION="${1:-12.2.0}"

# Set source and installation directories
GCC_SRC_DIR="/usr/local/src/gcc-${GCC_VERSION}"
GCC_INSTALL_DIR="/usr/local/gcc-${GCC_VERSION}"

# Define GPG keys for verification
# Source: https://gcc.gnu.org/releases.html
# The gnu mirros sites and GPG keys https://gcc.gnu.org/mirrors.html
# Note: The keys are subject to change, please verify from the official source as given above.
# The keys are used to verify the downloaded GCC tarball.
GCC_KEYS=(
    # 1024D/745C015A 1999-11-09 Gerald Pfeifer <gerald@pfeifer.com>
    "B215C1633BCA0477615F1B35A5B3A004745C015A"
    # 1024D/B75C61B8 2003-04-10 Mark Mitchell <mark@codesourcery.com>
    "B3C42148A44E6983B3E4CC0793FA9B1AB75C61B8"
    # 1024D/902C9419 2004-12-06 Gabriel Dos Reis <gdr@acm.org>
    "90AA470469D3965A87A5DCB494D03953902C9419"
    # 1024D/F71EDF1C 2000-02-13 Joseph Samuel Myers <jsm@polyomino.org.uk>
    "80F98B2E0DAB6C8281BDF541A7C8C3B2F71EDF1C"
    # 2048R/FC26A641 2005-09-13 Richard Guenther <richard.guenther@gmail.com>
    "7F74F97C103468EE5D750B583AB00996FC26A641"
    # 1024D/C3C45C06 2004-04-21 Jakub Jelinek <jakub@redhat.com>
    "33C235A34C46AA3FFB293709A328C3A2C3C45C06"
    # 4096R/09B5FA62 2020-05-28 Jakub Jelinek <jakub@redhat.com>
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

# Executes the provided command with 'sudo' if the current user is not root; otherwise, runs the command directly.
sudo_if() {
    COMMAND="$*"

    if [ "$(id -u)" -ne 0 ]; then
        sudo $COMMAND
    else
        $COMMAND
    fi
}

# Install required dependencies
sudo_if apt-get update
sudo_if apt-get install -y \
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

# Function to robustly download files with retries
robust_wget() {
    local url="$1"
    local output="$2"
    local retries=5
    local wait_seconds=5

    for ((i=1; i<=retries; i++)); do
        if wget -O "$output" "$url"; then
            return 0
        else
            echo "Attempt $i failed for $url. Retrying in $wait_seconds seconds..."
            sleep "$wait_seconds"
        fi
    done

    echo "Failed to download $url after $retries attempts."
    exit 1
}

cleanup() {
    echo "Cleaning up temporary files..."
    rm -rf "${build_dir:-}" "${GCC_SRC_DIR:-}"
    sudo_if apt-get clean
}

# Trap EXIT signal to ensure cleanup runs
trap cleanup EXIT

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
sudo_if mkdir -p "${GCC_SRC_DIR}"
sudo_if tar -xf "gcc-${GCC_VERSION}.tar.xz" -C "${GCC_SRC_DIR}" --strip-components=1
rm "gcc-${GCC_VERSION}.tar.xz" "gcc-${GCC_VERSION}.tar.xz.sig"

# Prepare GCC source
cd "${GCC_SRC_DIR}"
./contrib/download_prerequisites
for f in config.guess config.sub; do
    robust_wget "https://git.savannah.gnu.org/cgit/config.git/plain/$f?id=7d3d27baf8107b630586c962c057e22149653deb" "$f"
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
sudo_if make install-strip

# Update alternatives to use the new GCC version as the default version.
sudo_if update-alternatives --install /usr/bin/gcc gcc ${GCC_INSTALL_DIR}/bin/gcc 999
sudo_if update-alternatives --install /usr/bin/g++ g++ ${GCC_INSTALL_DIR}/bin/g++ 999
sudo_if update-alternatives --install /usr/bin/gcc-ar gcc-ar ${GCC_INSTALL_DIR}/bin/gcc-ar 999
sudo_if update-alternatives --install /usr/bin/gcc-nm gcc-nm ${GCC_INSTALL_DIR}/bin/gcc-nm 999
sudo_if update-alternatives --install /usr/bin/gcc-ranlib gcc-ranlib ${GCC_INSTALL_DIR}/bin/gcc-ranlib 999
sudo_if update-alternatives --install /usr/bin/gcov gcov ${GCC_INSTALL_DIR}/bin/gcov 999
sudo_if update-alternatives --install /usr/bin/gcov-dump gcov-dump ${GCC_INSTALL_DIR}/bin/gcov-dump 999
sudo_if update-alternatives --install /usr/bin/gcov-tool gcov-tool ${GCC_INSTALL_DIR}/bin/gcov-tool 999


# Verify installation
echo "Verifying GCC installation..."
gcc --version
g++ --version
if [ $? -ne 0 ]; then
    echo "GCC installation failed."
    exit 1
fi

echo "GCC ${GCC_VERSION} has been installed successfully in ${GCC_INSTALL_DIR}!"
