#!/bin/bash
cd $(dirname "$0")

source test-utils-fedora.sh root

# Run common tests
checkCommon

# Podman-specific tests
check "podman-installed" which podman
check "podman-version" podman --version
check "podman-info" podman info

# Check nested container operation
echo -e "\n🧪 Testing nested container (podman run)"
if podman run --rm alpine:latest echo "Hello from nested container"; then
    echo "✅  Passed!"
else
    echoStderr "❌ Nested container check failed."
    FAILED+=("nested-container")
fi

# Check optional tools (don't fail if not installed)
checkOptional() {
    LABEL=$1
    shift
    echo -e "\n🧪 Testing $LABEL (optional)"
    if "$@"; then 
        echo "✅  Passed!"
        return 0
    else
        echoStderr "⚠️  $LABEL not available (optional)"
        return 0  # Don't fail for optional checks
    fi
}

checkOptional "buildah" buildah --version
checkOptional "skopeo" skopeo --version
checkOptional "docker-alias" docker --version

# Report result
reportResults
