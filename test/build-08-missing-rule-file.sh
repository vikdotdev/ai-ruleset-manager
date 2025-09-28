#!/bin/sh
# Test build command with missing rule file

set -e
cd "$(dirname "$0")/.."

echo "Testing: Build with missing rule file"

# Test build with manifest that references non-existent rule
if LLM_RULES_DIR=test/fixtures ./scripts/ai-rules build --manifest test/fixtures/missing_rule/manifest --out test/tmp/build-08-missing-rule.md 2>test/tmp/build-08-stderr.txt; then
    echo "FAIL: Build should have failed with missing rule file"
    exit 1
fi

# Check that proper error message was displayed
if ! grep -q "Error: Rule file not found" test/tmp/build-08-stderr.txt; then
    echo "FAIL: Expected error message not found"
    echo "Stderr output:"
    cat test/tmp/build-08-stderr.txt
    exit 1
fi

# Check that the missing rule name is mentioned
if ! grep -q "nonexistent-rule" test/tmp/build-08-stderr.txt; then
    echo "FAIL: Missing rule name not mentioned in error"
    echo "Stderr output:"
    cat test/tmp/build-08-stderr.txt
    exit 1
fi

# Check that no output file was created
if [ -f "test/tmp/build-08-missing-rule.md" ]; then
    echo "FAIL: Output file should not have been created"
    exit 1
fi

echo "PASS: Build correctly fails with missing rule file"