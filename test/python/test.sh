#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

checkCommon
check "python" python --version

# Report result
reportResults
