#!/bin/bash

# Script to delete all .build folders recursively from the repository root
# This helps clean up build artifacts and free up disk space

set -e

# Get the repository root directory (2 levels up from this script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "Searching for .build folders in: $REPO_ROOT"
echo ""

# Find all .build directories
BUILD_DIRS=$(find "$REPO_ROOT" -type d -name ".build" 2>/dev/null || true)

if [ -z "$BUILD_DIRS" ]; then
    echo "No .build folders found."
    exit 0
fi

# Count the directories
DIR_COUNT=$(echo "$BUILD_DIRS" | wc -l | tr -d ' ')

echo "Found $DIR_COUNT .build folder(s):"
echo "$BUILD_DIRS"
echo ""

# Ask for confirmation
read -p "Do you want to delete these folders? (y/N) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Deleting .build folders..."
    echo "$BUILD_DIRS" | while read -r dir; do
        if [ -d "$dir" ]; then
            echo "Deleting: $dir"
            rm -rf "$dir"
        fi
    done
    echo ""
    echo "Done! Deleted $DIR_COUNT .build folder(s)."
else
    echo "Cancelled. No folders were deleted."
    exit 0
fi
