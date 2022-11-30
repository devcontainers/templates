#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Remote - Containers does not auto-sync UID/GID for Docker Compose,
# so make sure test project prvs match the non-root user in the container.
fixTestProjectFolderPrivs

# Run common tests
checkCommon

# template specific tests
checkExtension "ms-azuretools.vscode-docker"
check "docker" docker ps -a
check "docker-compose" docker-compose --version
check "docker-init-exists" ls -la /usr/local/share/docker-init.sh

# Report result
reportResults
