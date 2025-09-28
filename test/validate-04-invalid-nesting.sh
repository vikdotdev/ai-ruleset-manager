#!/bin/sh
# Test validate command with invalid nesting

set -e
cd "$(dirname "$0")/.."

echo "Testing: Validate with invalid nesting"

# Test validate with manifest that has invalid nesting
if LLM_RULES_DIR=test/fixtures ./scripts/ai-rules validate --manifest test/fixtures/invalid_nesting/manifest >test/tmp/validate-04-output.txt 2>&1; then
    echo "FAIL: Validate should have failed with invalid nesting"
    exit 1
fi

# Check that invalid nesting was detected
if ! grep -q "Invalid nesting" test/tmp/validate-04-output.txt; then
    echo "FAIL: Expected invalid nesting message not found"
    echo "Output:"
    cat test/tmp/validate-04-output.txt
    exit 1
fi

# Check that the specific level error is mentioned
if ! grep -q "level 3 follows level 1" test/tmp/validate-04-output.txt; then
    echo "FAIL: Specific nesting error not mentioned"
    echo "Output:"
    cat test/tmp/validate-04-output.txt
    exit 1
fi

# Check that validation failed
if ! grep -q "has.*missing rule(s)" test/tmp/validate-04-output.txt; then
    echo "FAIL: Validation failure message not found"
    echo "Output:"
    cat test/tmp/validate-04-output.txt
    exit 1
fi

echo "PASS: Validate correctly fails with invalid nesting"