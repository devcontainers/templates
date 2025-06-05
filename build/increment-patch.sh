#!/bin/bash

# Increments the patch version (x.y.z -> x.y.<z+1>) of all devcontainer-template.json files in the src/ directory.
# Expects a ''.prettierrc' config file in the root

cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1

find src/ -name 'devcontainer-template.json' -exec bash -c '
  for file; do
    version=$(jq -r ".version" "$file")
    IFS="." read -r major minor patch <<< "$version"
    new_patch=$((patch + 1))
    new_version="$major.$minor.$new_patch"
    jq ".version = \"$new_version\"" "$file" > tmp.$$.json && mv tmp.$$.json "$file"
  done
' bash {} +

npx prettier --write src/**/devcontainer-template.json