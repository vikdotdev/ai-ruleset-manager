#!/bin/sh
# Test build command with invalid nesting auto-correction (level 3 follows level 1)

set -e
cd "$(dirname "$0")/.."

echo "Testing: Build with invalid nesting auto-correction"

# Test build with manifest that has invalid nesting - should succeed with warning
if ! LLM_RULES_DIR=test/fixtures ./scripts/ai-rules build --manifest test/fixtures/invalid_nesting/manifest --out test/tmp/build-09-invalid-nesting.md 2>test/tmp/build-09-stderr.txt; then
    echo "FAIL: Build should have succeeded with auto-correction"
    echo "Stderr output:"
    cat test/tmp/build-09-stderr.txt
    exit 1
fi

# Check that proper warning message was displayed
if ! grep -q "Warning: Invalid nesting in manifest" test/tmp/build-09-stderr.txt; then
    echo "FAIL: Expected warning message not found"
    echo "Stderr output:"
    cat test/tmp/build-09-stderr.txt
    exit 1
fi

# Check that the specific level error is mentioned
if ! grep -q "Level 3 follows level 1" test/tmp/build-09-stderr.txt; then
    echo "FAIL: Specific nesting error not mentioned"
    echo "Stderr output:"
    cat test/tmp/build-09-stderr.txt
    exit 1
fi

# Check that auto-correction message is shown
if ! grep -q "Auto-correcting to level 2" test/tmp/build-09-stderr.txt; then
    echo "FAIL: Auto-correction message not found"
    echo "Stderr output:"
    cat test/tmp/build-09-stderr.txt
    exit 1
fi

# Check that output file was created
if [ ! -f "test/tmp/build-09-invalid-nesting.md" ]; then
    echo "FAIL: Output file should have been created"
    exit 1
fi

echo "PASS: Build correctly auto-corrects invalid nesting"