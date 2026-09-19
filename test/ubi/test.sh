#!/bin/bash
cd $(dirname "$0")

source test-utils-ubi.sh vscode

# Run common tests
checkCommon

# UBI-specific tests
check "redhat-release" cat /etc/redhat-release
check "ubi-image" grep -q "Red Hat" /etc/redhat-release

# Report result
reportResults
