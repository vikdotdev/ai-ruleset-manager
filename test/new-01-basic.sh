#!/bin/sh
# Test new command

set -e
cd "$(dirname "$0")/.."

echo "Testing: New command"

# Test creating new database - capture output
LLM_RULES_DIR=test/tmp ./scripts/ai-rules new --database testdb > test/tmp/new-01-output.txt

# Create expected output for new command
cat > test/tmp/new-01-expected.txt <<'EOF'
Creating new database: testdb
✓ Created database structure at test/tmp/testdb
✓ Created manifest: test/tmp/testdb/manifest
✓ Created example rule: test/tmp/testdb/rules/basic.md

Next steps:
1. Edit test/tmp/testdb/manifest to include your rules
2. Add rule files to test/tmp/testdb/rules/
3. Build with: ai-rules build --manifest test/tmp/testdb/manifest
EOF

# Compare actual vs expected
if ! diff -q "test/tmp/new-01-output.txt" "test/tmp/new-01-expected.txt" >/dev/null 2>&1; then
    echo "FAIL: New command output does not match expected"
    echo "Expected:"
    cat "test/tmp/new-01-expected.txt"
    echo ""
    echo "Actual:"
    cat "test/tmp/new-01-output.txt"
    echo ""
    echo "Diff:"
    diff "test/tmp/new-01-expected.txt" "test/tmp/new-01-output.txt" || true
    exit 1
fi

# Check that files were actually created
if [ ! -d "test/tmp/testdb" ] || [ ! -f "test/tmp/testdb/manifest" ] || [ ! -f "test/tmp/testdb/rules/basic.md" ]; then
    echo "FAIL: Required files/directories not created"
    exit 1
fi

# Verify manifest content
cat > test/tmp/new-01-expected-manifest <<'EOF'
# Add your rule files below using the pipe format

| basic
# | advanced

# Include rules from other databases:
# | other-database/specific-rule
EOF

if ! diff -q "test/tmp/testdb/manifest" "test/tmp/new-01-expected-manifest" >/dev/null 2>&1; then
    echo "FAIL: Generated manifest does not match expected"
    exit 1
fi

# Test that creating existing database fails with specific error
LLM_RULES_DIR=test/tmp ./scripts/ai-rules new --database testdb > test/tmp/new-01-error.txt 2>&1 || true

# Create expected error output
cat > test/tmp/new-01-expected-error.txt <<'EOF'
Error: Database 'testdb' already exists at test/tmp/testdb
EOF

# Compare actual vs expected error output
if ! diff -q "test/tmp/new-01-error.txt" "test/tmp/new-01-expected-error.txt" >/dev/null 2>&1; then
    echo "FAIL: New command error output does not match expected"
    echo "Expected:"
    cat "test/tmp/new-01-expected-error.txt"
    echo ""
    echo "Actual:"
    cat "test/tmp/new-01-error.txt"
    echo ""
    echo "Diff:"
    diff "test/tmp/new-01-expected-error.txt" "test/tmp/new-01-error.txt" || true
    exit 1
fi

echo "PASS: New command"
