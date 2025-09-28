#!/bin/sh
# Test new command with missing --database argument

set -e
cd "$(dirname "$0")/.."

echo "Testing: New command with missing database argument"

# Test new command without --database argument
if LLM_RULES_DIR=test/tmp ./scripts/ai-rules new 2>test/tmp/new-02-stderr.txt; then
    echo "FAIL: New command should have failed without --database"
    exit 1
fi

# Check that proper error message was displayed
if ! grep -q "Error: --database is required" test/tmp/new-02-stderr.txt; then
    echo "FAIL: Expected error message not found"
    echo "Stderr output:"
    cat test/tmp/new-02-stderr.txt
    exit 1
fi

echo "PASS: New command correctly fails without --database argument"