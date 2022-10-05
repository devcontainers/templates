#!/bin/bash
cd $(dirname "$0")

source test-utils.sh

# Run common tests
checkCommon

# Run template specific tests
checkExtension "golang.Go"

check "lib pq check" go list github.com/lib/pq
check "go test program" go run hello.go

## Report result
reportResults
