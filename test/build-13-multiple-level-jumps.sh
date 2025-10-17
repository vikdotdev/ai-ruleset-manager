#!/bin/sh
# Test auto-correction for multiple different level jumps

set -e
cd "$(dirname "$0")/.."

echo "Testing: Auto-correction for multiple level jumps"

# Test build with various level jumps - should auto-correct all and emit warnings
LLM_RULES_DIR=test/fixtures ./scripts/ai-rules build --manifest test/fixtures/multiple_level_jumps/manifest --out test/tmp/build-13-multiple-jumps.md 2>test/tmp/build-13-stderr.txt

# Check that output file was created
if [ ! -f "test/tmp/build-13-multiple-jumps.md" ]; then
    echo "FAIL: Output file not created"
    exit 1
fi

# Count the number of warnings - should be 4
warning_count=$(grep -c "Warning: Invalid nesting" test/tmp/build-13-stderr.txt || echo 0)
if [ "$warning_count" -ne 4 ]; then
    echo "FAIL: Expected 4 warnings, got $warning_count"
    echo "Stderr content:"
    cat test/tmp/build-13-stderr.txt
    exit 1
fi

# Check specific auto-corrections
if ! grep -q "Level 3 follows level 1" test/tmp/build-13-stderr.txt; then
    echo "FAIL: Level 3→1 correction not found"
    exit 1
fi

if ! grep -q "Level 4 follows level 2" test/tmp/build-13-stderr.txt; then
    echo "FAIL: Level 4→2 correction not found"
    exit 1
fi

if ! grep -q "Level 5 follows level 3" test/tmp/build-13-stderr.txt; then
    echo "FAIL: Level 5→3 correction not found"
    exit 1
fi

if ! grep -q "Level 5 follows level 1" test/tmp/build-13-stderr.txt; then
    echo "FAIL: Level 5→1 correction not found"
    exit 1
fi

# Create expected output with corrected nesting levels
cat > test/tmp/build-13-expected.md <<'EOF'
# Rule: multiple_level_jumps/level1
## level1 Rule

Test rule content.

## Rule: multiple_level_jumps/jump-from-1-to-3
### jump-from-1-to-3 Rule

Test rule content.

## Rule: multiple_level_jumps/level2
### level2 Rule

Test rule content.

### Rule: multiple_level_jumps/jump-from-2-to-4
#### jump-from-2-to-4 Rule

Test rule content.

### Rule: multiple_level_jumps/level3
#### level3 Rule

Test rule content.

#### Rule: multiple_level_jumps/jump-from-3-to-5
##### jump-from-3-to-5 Rule

Test rule content.

# Rule: multiple_level_jumps/back-to-1
## back-to-1 Rule

Test rule content.

## Rule: multiple_level_jumps/big-jump-from-1-to-5
### big-jump-from-1-to-5 Rule

Test rule content.
EOF

# Compare actual vs expected
if ! diff -q "test/tmp/build-13-multiple-jumps.md" "test/tmp/build-13-expected.md" >/dev/null 2>&1; then
    echo "FAIL: Auto-corrected output does not match expected"
    echo "Expected:"
    cat "test/tmp/build-13-expected.md"
    echo ""
    echo "Actual:"
    cat "test/tmp/build-13-multiple-jumps.md"
    echo ""
    echo "Diff:"
    diff "test/tmp/build-13-expected.md" "test/tmp/build-13-multiple-jumps.md" || true
    exit 1
fi

echo "PASS: Auto-correction for multiple level jumps"