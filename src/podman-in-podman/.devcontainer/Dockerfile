# Podman-in-Podman for Dev Containers
# Allows running containers inside a dev container using Podman

# [Choice] Podman version tag: latest or any version (e.g., v5.7.1, v5.7, v5, 5.7.1)
# Version tags use 'v' prefix (e.g., v5.7.1, v5.7, v5)
# The 'v' prefix is optional in input - if you specify '5.7.1', it will be used as 'v5.7.1'
# For best results, specify the full tag with 'v' prefix (e.g., 'v5.7.1', 'v5.7', 'v5')
ARG VARIANT=latest
ARG PODMAN_TAG
ARG INSTALL_BUILDAH="true"
ARG INSTALL_SKOPEO="true"

# Official Podman images from quay.io
# Tag format: quay.io/podman/stable:latest or quay.io/podman/stable:v5.7.1, v5.7, v5, etc.
# PODMAN_TAG is calculated and passed from devcontainer.json:
# - 'latest' -> 'latest'
# - Other versions -> add 'v' prefix if not present (e.g., '5.7.1' -> 'v5.7.1', 'v5.7.1' -> 'v5.7.1')
# Default to 'latest' if PODMAN_TAG is not provided
FROM quay.io/podman/stable:${PODMAN_TAG:-latest}

# For official Podman images, Podman is already installed
# Install additional tools and optional components
RUN dnf install -y \
        shadow-utils \
        sudo \
        curl \
        wget \
        ca-certificates \
        findutils \
        which \
        tar \
        gzip \
        unzip \
        procps-ng \
        glibc-langpack-en \
        podman-docker \
    && dnf clean all

# Install optional tools based on build arguments
# Note: ARG must be redeclared after FROM to be available in this stage
ARG INSTALL_BUILDAH
ARG INSTALL_SKOPEO
RUN if [ "${INSTALL_BUILDAH}" = "true" ]; then \
        dnf install -y buildah && dnf clean all; \
    fi \
    && if [ "${INSTALL_SKOPEO}" = "true" ]; then \
        dnf install -y skopeo && dnf clean all; \
    fi

# Configure subuid/subgid for rootless containers (will be set up by common-utils feature)
# Using UID/GID 1001 to avoid conflicts with existing users in official Podman image
RUN echo "vscode:100000:65536" >> /etc/subuid \
    && echo "vscode:100000:65536" >> /etc/subgid \
    && echo "1001:100000:65536" >> /etc/subuid \
    && echo "1001:100000:65536" >> /etc/subgid

# Configure Podman for nested container operation
RUN mkdir -p /etc/containers \
    && echo '[containers]' > /etc/containers/containers.conf \
    && echo 'netns="host"' >> /etc/containers/containers.conf \
    && echo 'userns="host"' >> /etc/containers/containers.conf \
    && echo 'ipcns="host"' >> /etc/containers/containers.conf \
    && echo 'utsns="host"' >> /etc/containers/containers.conf \
    && echo 'cgroupns="host"' >> /etc/containers/containers.conf \
    && echo 'log_driver = "k8s-file"' >> /etc/containers/containers.conf \
    && echo '' >> /etc/containers/containers.conf \
    && echo '[engine]' >> /etc/containers/containers.conf \
    && echo 'cgroup_manager = "cgroupfs"' >> /etc/containers/containers.conf \
    && echo 'events_logger = "file"' >> /etc/containers/containers.conf

# Configure storage
RUN echo '[storage]' > /etc/containers/storage.conf \
    && echo 'driver = "overlay"' >> /etc/containers/storage.conf \
    && echo '' >> /etc/containers/storage.conf \
    && echo '[storage.options.overlay]' >> /etc/containers/storage.conf \
    && echo 'mount_program = "/usr/bin/fuse-overlayfs"' >> /etc/containers/storage.conf

# Set locale to avoid warnings
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Create /etc/machine-id if it doesn't exist (required by some tools)
# This is a dummy machine-id for container environments (32 hex chars, no hyphens per systemd spec)
RUN if [ ! -f /etc/machine-id ]; then \
        if [ -f /proc/sys/kernel/random/uuid ]; then \
            # Convert UUID format to 32-char hex string (remove hyphens) \
            cat /proc/sys/kernel/random/uuid | tr -d '-' > /etc/machine-id; \
        elif command -v dbus-uuidgen >/dev/null 2>&1; then \
            dbus-uuidgen | tr -d '-' > /etc/machine-id; \
        else \
            # Fallback: generate 32 hex characters \
            od -An -N16 -tx1 /dev/urandom | tr -d ' \n' > /etc/machine-id || \
            echo "00000000000000000000000000000000" > /etc/machine-id; \
        fi; \
    fi

# Note: The common-utils feature will create the vscode user
