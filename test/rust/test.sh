#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

checkCommon
check "rust" rust --version

# Report result
reportResults
