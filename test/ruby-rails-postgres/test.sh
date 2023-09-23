#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Remote - Containers does not auto-sync UID/GID for Docker Compose,
# so make sure test project prvs match the non-root user in the container.
fixTestProjectFolderPrivs

# Run common tests
checkCommon

# Run devcontainer specific tests
check "rails" rails --version
check "user has write permission to rvm gems" [ -w /usr/local/rvm/gems ]
check "user has write permission to rvm gems default" [ -w /usr/local/rvm/gems/default ]
check "user can install gems" gem install github-markup

# Report result
reportResults
