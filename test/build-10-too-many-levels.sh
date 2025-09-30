#!/bin/sh
# Test build command with too many nesting levels (>6)

set -e
cd "$(dirname "$0")/.."

echo "Testing: Build with too many nesting levels"

# Test build with manifest that has >6 nesting levels
if LLM_RULES_DIR=test/fixtures ./scripts/ai-rules build --manifest test/fixtures/too_many_levels/manifest --out test/tmp/build-10-too-many-levels.md 2>test/tmp/build-10-stderr.txt; then
    echo "FAIL: Build should have failed with too many nesting levels"
    exit 1
fi

# Check that proper error message was displayed
if ! grep -q "Error: Too many nesting levels" test/tmp/build-10-stderr.txt; then
    echo "FAIL: Expected error message not found"
    echo "Stderr output:"
    cat test/tmp/build-10-stderr.txt
    exit 1
fi

# Check that the maximum is mentioned
if ! grep -q "Maximum is 6" test/tmp/build-10-stderr.txt; then
    echo "FAIL: Maximum nesting level not mentioned"
    echo "Stderr output:"
    cat test/tmp/build-10-stderr.txt
    exit 1
fi

# Check that no output file was created
if [ -f "test/tmp/build-10-too-many-levels.md" ]; then
    echo "FAIL: Output file should not have been created"
    exit 1
fi

echo "PASS: Build correctly fails with too many nesting levels"