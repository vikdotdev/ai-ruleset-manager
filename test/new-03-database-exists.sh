#!/bin/sh
# Test new command when database already exists

set -e
cd "$(dirname "$0")/.."

echo "Testing: New command when database already exists"

# Create a test database first
mkdir -p test/tmp/existing-db

# Test new command with existing database
if LLM_RULES_DIR=test/tmp ./scripts/llm-rules new --database existing-db 2>test/tmp/new-03-stderr.txt; then
    echo "FAIL: New command should have failed with existing database"
    exit 1
fi

# Check that proper error message was displayed
if ! grep -q "Error: Database 'existing-db' already exists" test/tmp/new-03-stderr.txt; then
    echo "FAIL: Expected error message not found"
    echo "Stderr output:"
    cat test/tmp/new-03-stderr.txt
    exit 1
fi

# Cleanup
rm -rf test/tmp/existing-db

echo "PASS: New command correctly fails when database exists"