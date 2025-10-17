#!/bin/sh
# Test auto-correction of invalid nesting with warning

set -e
cd "$(dirname "$0")/.."

echo "Testing: Auto-correction of invalid nesting with warning"

# Test build with invalid nesting - should auto-correct and emit warning
LLM_RULES_DIR=test/fixtures ./scripts/ai-rules build --manifest test/fixtures/nesting_warning/manifest --out test/tmp/build-12-nesting-warning.md 2>test/tmp/build-12-stderr.txt

# Check that output file was created (should succeed despite invalid nesting)
if [ ! -f "test/tmp/build-12-nesting-warning.md" ]; then
    echo "FAIL: Output file not created - build should have succeeded with auto-correction"
    exit 1
fi

# Check that warning was emitted to stderr
if ! grep -q "Warning: Invalid nesting" test/tmp/build-12-stderr.txt; then
    echo "FAIL: Warning about invalid nesting not found in stderr"
    echo "Stderr content:"
    cat test/tmp/build-12-stderr.txt
    exit 1
fi

if ! grep -q "Auto-correcting to level 2" test/tmp/build-12-stderr.txt; then
    echo "FAIL: Auto-correction message not found in stderr"
    echo "Stderr content:"
    cat test/tmp/build-12-stderr.txt
    exit 1
fi

# Create expected output (deeply-nested should be at level 2, not 3)
cat > test/tmp/build-12-expected.md <<'EOF'
# Rule: nesting_warning/parent
## Parent Rule

This is a parent rule.

## Rule: nesting_warning/deeply-nested
### Deeply Nested Rule

This should be treated as level 2, not 3.

# Rule: nesting_warning/another-parent
## Another Parent Rule

Another parent rule.
EOF

# Compare actual vs expected
if ! diff -q "test/tmp/build-12-nesting-warning.md" "test/tmp/build-12-expected.md" >/dev/null 2>&1; then
    echo "FAIL: Auto-corrected output does not match expected"
    echo "Expected:"
    cat "test/tmp/build-12-expected.md"
    echo ""
    echo "Actual:"
    cat "test/tmp/build-12-nesting-warning.md"
    echo ""
    echo "Diff:"
    diff "test/tmp/build-12-expected.md" "test/tmp/build-12-nesting-warning.md" || true
    exit 1
fi

echo "PASS: Auto-correction of invalid nesting with warning"