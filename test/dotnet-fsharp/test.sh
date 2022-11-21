#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Run common tests
checkCommon

# template specific tests
checkExtension "ms-dotnettools.csharp"
checkExtension "ionide.ionide-fsharp"
check "dotnet" dotnet --info
check "nuget" dotnet restore
check "msbuild" dotnet msbuild
sudo rm -rf obj bin

# Report result
reportResults