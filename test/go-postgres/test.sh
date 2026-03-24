#!/bin/bash
cd $(dirname "$0")

source test-utils.sh

# Run common tests
checkCommon

# Run template specific tests
checkExtension "golang.Go"

echo "=== DNS diagnostics ==="
echo "--- /etc/resolv.conf ---"
cat /etc/resolv.conf || true
echo "--- getent hosts proxy.golang.org ---"
getent hosts proxy.golang.org || true
echo "--- getent hosts github.com ---"
getent hosts github.com || true
echo "--- curl proxy.golang.org (headers) ---"
curl -I https://proxy.golang.org 2>/dev/null | head -n 5 || true
echo "======================="

check "lib pq check" go list github.com/lib/pq
check "go test program" go run hello.go

## Report result
reportResults
