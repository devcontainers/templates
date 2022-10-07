#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

checkCommon
check "ruby" ruby --version

# Report result
reportResults
