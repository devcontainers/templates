# Fedora base image for Dev Containers
# [Choice] Fedora version: 43, 42, 41, latest, rawhide
ARG VARIANT=43
FROM registry.fedoraproject.org/fedora:${VARIANT}

# Install base packages needed for Dev Container features
RUN dnf install -y \
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
        glibc-langpack-en \
    && dnf clean all

# Set locale to avoid warnings
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Note: The common-utils feature will create the vscode user and install additional tools

