#!/bin/sh
# Test automatic creation of build/ directory when using default output

set -e
cd "$(dirname "$0")/.."

echo "Testing: Automatic creation of build/ directory"

# Remove build directory if it exists
rm -rf build

# Test build with default output (no --out flag) - should auto-create build/ directory
LLM_RULES_DIR=test/fixtures ./scripts/ai-rules build --manifest test/fixtures/basic/manifest

# Check that build directory was created
if [ ! -d "build" ]; then
    echo "FAIL: build/ directory was not created"
    exit 1
fi

# Check that output file was created
if [ ! -f "build/basic.md" ]; then
    echo "FAIL: build/basic.md was not created"
    exit 1
fi

# Test that custom directories still need to exist (should fail)
rm -rf /tmp/test-nonexistent-dir
if LLM_RULES_DIR=test/fixtures ./scripts/ai-rules build --manifest test/fixtures/basic/manifest --out /tmp/test-nonexistent-dir/custom.md 2>test/tmp/build-14-stderr.txt; then
    echo "FAIL: Build should have failed with non-existent custom directory"
    exit 1
fi

# Check that proper error message was displayed
if ! grep -q "Output directory does not exist: /tmp/test-nonexistent-dir" test/tmp/build-14-stderr.txt; then
    echo "FAIL: Expected error message not found"
    echo "Stderr output:"
    cat test/tmp/build-14-stderr.txt
    exit 1
fi

# Test that custom directories work when they exist
mkdir -p /tmp/test-custom-dir
if ! LLM_RULES_DIR=test/fixtures ./scripts/ai-rules build --manifest test/fixtures/basic/manifest --out /tmp/test-custom-dir/custom.md; then
    echo "FAIL: Build should have succeeded with existing custom directory"
    exit 1
fi

# Check that custom output file was created
if [ ! -f "/tmp/test-custom-dir/custom.md" ]; then
    echo "FAIL: Custom output file was not created"
    exit 1
fi

# Cleanup
rm -rf /tmp/test-custom-dir

echo "PASS: Automatic creation of build/ directory"