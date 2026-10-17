#!/bin/bash
cd $(dirname "$0")

source test-utils-fedora.sh vscode

# Run common tests
checkCommon

# Fedora-specific tests
check "fedora-release" cat /etc/fedora-release

# Report result
reportResults
