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
check "nvm-node" bash -c ". /usr/local/share/nvm/nvm.sh && node --version"

# Report result
reportResults
