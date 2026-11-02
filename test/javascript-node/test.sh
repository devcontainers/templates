#!/bin/bash
cd $(dirname "$0")

source test-utils.sh node

check "corepack_setup" bash -c 'sudo npm install --global --force corepack@0.36.0 && sudo corepack enable && corepack prepare yarn@4.9.4 --activate'
check "yarn_version_new" yarn --version

# Run common tests
checkCommon

# template specific tests
checkExtension "dbaeumer.vscode-eslint"
check "node" node --version
sudo rm -f yarn.lock
check "yarn" yarn install
sudo rm -f package-lock.json
check "npm" npm install
check "eslint" eslint server.js
check "test-project" npm run test
npm config delete prefix
check "nvm" bash -c ". /usr/local/share/nvm/nvm.sh && nvm install 8"
check "nvm-node" bash -c ". /usr/local/share/nvm/nvm.sh && node --version"
sudo rm -rf node_modules

# Report result
reportResults
