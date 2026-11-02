#!/bin/bash
cd $(dirname "$0")

source test-utils.sh node

sudo corepack enable && corepack prepare yarn@4.9.4 --activate
check "yarn_version_new" yarn --version

# Run common tests
checkCommon

# template specific tests
checkExtension "dbaeumer.vscode-eslint"
check "node" node --version
sudo rm -f yarn.lock
check "yarn" yarn install
sudo rm -f package-lock.json
check "eslint" eslint --no-warn-ignored src/server.ts
check "typescript" npm run compile
check "test-project" npm run test
npm config delete prefix
check "nvm" bash -c ". /usr/local/share/nvm/nvm.sh && nvm install 8"
check "nvm-node" bash -c ". /usr/local/share/nvm/nvm.sh && node --version"
sudo rm -rf node_modules out

# Report result
reportResults
