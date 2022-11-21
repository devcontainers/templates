#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Run common tests
checkCommon

# Image specific tests
check "jekyll" jekyll --version
check "gem" gem --version
check "ruby" ruby --version
check "bundler" bundler --version
check "github-pages" github-pages --version

# Report result
reportResults
