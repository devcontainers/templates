#!/bin/bash
cd $(dirname "$0")

source test-utils.sh vscode

# Run common tests
checkCommon

# Prep - Download Maven for building (network_mode fix enables outbound access)
echo -e "\nResolving Maven..."
MAVEN_VERSION="3.9.9"
MAVEN_DIR="apache-maven-${MAVEN_VERSION}"

if command -v mvn >/dev/null 2>&1; then
    MVN_CMD="mvn"
else
    echo "mvn not found, downloading Apache Maven ${MAVEN_VERSION}..."
    curl -fsSL "https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_DIR}-bin.tar.gz" | tar -xzf -
    MVN_CMD="$(pwd)/${MAVEN_DIR}/bin/mvn"
fi

# template specific tests
checkExtension "vscjava.vscode-java-pack"
check "java" java -version
check "build-and-test-jar" "$MVN_CMD" -q package
check "test-project" java -jar target/my-app-1.0-SNAPSHOT.jar

# Clean up
rm -rf "${MAVEN_DIR}"

# Report result
reportResults
