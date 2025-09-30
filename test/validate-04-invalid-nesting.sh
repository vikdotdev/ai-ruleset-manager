#!/bin/sh
# Test validate command with invalid nesting warning

set -e
cd "$(dirname "$0")/.."

echo "Testing: Validate with invalid nesting warning"

# Test validate with manifest that has invalid nesting - should succeed with warning
if ! LLM_RULES_DIR=test/fixtures ./scripts/ai-rules validate --manifest test/fixtures/invalid_nesting/manifest >test/tmp/validate-04-output.txt 2>&1; then
    echo "FAIL: Validate should have succeeded with warning"
    echo "Output:"
    cat test/tmp/validate-04-output.txt
    exit 1
fi

# Check that nesting warning was displayed
if ! grep -q "Nesting warning" test/tmp/validate-04-output.txt; then
    echo "FAIL: Expected nesting warning message not found"
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

# Check that auto-correction is mentioned
if ! grep -q "will auto-correct to" test/tmp/validate-04-output.txt; then
    echo "FAIL: Auto-correction message not found"
    echo "Output:"
    cat test/tmp/validate-04-output.txt
    exit 1
fi

# Check that validation succeeded
if ! grep -q "is valid!" test/tmp/validate-04-output.txt; then
    echo "FAIL: Validation success message not found"
    echo "Output:"
    cat test/tmp/validate-04-output.txt
    exit 1
fi

echo "PASS: Validate correctly shows warning for invalid nesting"