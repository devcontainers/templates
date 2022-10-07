#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Run common tests
checkCommon

# Image specific tests
check "go" go version

# Report result
reportResults
