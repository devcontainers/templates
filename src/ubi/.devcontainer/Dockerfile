# Red Hat Universal Base Image (UBI) for Dev Containers
# [Choice] UBI version: 10, 9, 8
ARG UBI_VERSION=10
# [Choice] Variant: ubi, ubi-minimal, ubi-init
ARG VARIANT=ubi

FROM registry.access.redhat.com/ubi${UBI_VERSION}/${VARIANT}:latest

ARG VARIANT

# Install base packages needed for Dev Container features
# Use microdnf for ubi-minimal, dnf for others
# For UBI 9, curl-minimal is pre-installed and conflicts with curl
# Remove curl-minimal first using rpm (more reliable than microdnf remove)
RUN if [ "${VARIANT}" = "ubi-minimal" ]; then \
        rpm -e --nodeps curl-minimal 2>/dev/null || true; \
    fi

RUN if [ "${VARIANT}" = "ubi-minimal" ]; then \
        microdnf install -y \
            curl \
            wget \
            ca-certificates \
            findutils \
            which \
            tar \
            gzip \
            unzip \
            shadow-utils \
            procps-ng \
            sudo \
        && microdnf clean all; \
    else \
        # UBI 9 has curl-minimal pre-installed, use --allowerasing to replace with curl
        dnf install -y --allowerasing \
            curl \
            wget \
            ca-certificates \
            findutils \
            which \
            tar \
            gzip \
            unzip \
            shadow-utils \
            procps-ng \
            sudo \
        && dnf clean all; \
    fi

# Note: The common-utils feature will create the vscode user and install additional tools

