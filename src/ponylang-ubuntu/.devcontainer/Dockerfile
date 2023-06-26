FROM buildpack-deps:jammy-curl

# Options for setup script
ARG INSTALL_ZSH="true"
ARG UPGRADE_PACKAGES="true"
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
# Pony versions for linking, these will change over time and break the build until updated
# the only way to prevent this would be to understand and change, if necessary, the pony installer or ponyup commands
ARG CORRAL_VER=0.7.0
ARG CHANGELOG_TOOL_VER=0.5.0
ARG PONYC_VER=0.55.0
# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
COPY library-scripts/*.sh library-scripts/*.env /tmp/library-scripts/
RUN yes | unminimize 2>&1 \ 
    && bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# [Optional] Uncomment this section to install additional OS packages.
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    clang-15 \
    curl \
    g++ \
    git \
    llvm-15 \
    make \
  && rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf -o ponyup-init.sh https://raw.githubusercontent.com/ponylang/ponyup/latest-release/ponyup-init.sh
RUN export SHELL=/bin/sh \
 && sh ponyup-init.sh \
 && export PATH=/root/.local/share/ponyup/bin:$PATH \
 && ponyup update ponyc release \
 && ponyup update corral release \
 && ponyup update changelog-tool release \
 && mkdir -p /usr/local/share \
 && mv /root/.local/share/ponyup /usr/local/share/ponyup \
 && chmod a+rX /usr/local \
 && chmod a+rX /usr/local/share \
 && chmod -R a+rX /usr/local/share/ponyup \
 && unlink /usr/local/share/ponyup/bin/corral \
 && unlink /usr/local/share/ponyup/bin/ponyc \
 && unlink /usr/local/share/ponyup/bin/changelog-tool \
 && ln -s /usr/local/share/ponyup/ponyc-release-${PONYC_VER}-x86_64-linux-ubuntu22.04/bin/ponyc /usr/local/share/ponyup/bin/ponyc \
 && ln -s /usr/local/share/ponyup/corral-release-${CORRAL_VER}-x86_64-linux/bin/corral /usr/local/share/ponyup/bin/corral \
 && ln -s /usr/local/share/ponyup/changelog-tool-release-${CHANGELOG_TOOL_VER}-linux/bin/changelog-tool /usr/local/share/ponyup/bin/changelog-tool \
 && ln -s /usr/local/share/ponyup/ponyc-release-${PONYC_VER}-x86_64-linux-ubuntu22.04/bin/ponyc /usr/local/bin/ponyc \
 && ln -s /usr/local/share/ponyup/corral-release-${CORRAL_VER}-x86_64-linux/bin/corral /usr/local/bin/corral \
 && ln -s /usr/local/share/ponyup/changelog-tool-release-${CHANGELOG_TOOL_VER}-linux/bin/changelog-tool /usr/local/bin/changelog-tool \
 && ln -s /usr/local/share/ponyup/bin/ponyup /usr/local/bin/ponyup