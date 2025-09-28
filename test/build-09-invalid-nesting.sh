#!/bin/sh
# Test build command with invalid nesting (level 3 follows level 1)

set -e
cd "$(dirname "$0")/.."

echo "Testing: Build with invalid nesting"

# Test build with manifest that has invalid nesting
if LLM_RULES_DIR=test/fixtures ./scripts/llm-rules build --manifest test/fixtures/invalid_nesting/manifest --out test/tmp/build-09-invalid-nesting.md 2>test/tmp/build-09-stderr.txt; then
    echo "FAIL: Build should have failed with invalid nesting"
    exit 1
fi

# Check that proper error message was displayed
if ! grep -q "Error: Invalid nesting in manifest" test/tmp/build-09-stderr.txt; then
    echo "FAIL: Expected error message not found"
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

# Check that no output file was created
if [ -f "test/tmp/build-09-invalid-nesting.md" ]; then
    echo "FAIL: Output file should not have been created"
    exit 1
fi

echo "PASS: Build correctly fails with invalid nesting"