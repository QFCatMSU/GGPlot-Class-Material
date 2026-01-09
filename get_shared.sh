#!/bin/bash
# update_shared_lessons.sh
# Usage: ./update_shared_lessons.sh <shared_repo_url> <branch>
# Example: bash get_shared.sh https://github.com/QFCatMSU/ClassSetup main

SHARED_REPO="$1"
BRANCH="${2:-main}"      # default to main branch
TEMP_DIR="temp-shared"
TARGET_DIR="lessons"

if [ -z "$SHARED_REPO" ]; then
    echo "Usage: $0 <shared_repo_url> [branch]"
    exit 1
fi

# 1️⃣ Remove any previous temp directory
rm -rf "$TEMP_DIR"

# 2️⃣ Clone only the latest snapshot (shallow)
git clone --depth 1 --branch "$BRANCH" "$SHARED_REPO" "$TEMP_DIR"

if [ $? -ne 0 ]; then
    echo "Error: Failed to clone $SHARED_REPO"
    exit 2
fi

# 3️⃣ Merge shared lessons into class lessons
#    - preserves folder structure
#    - overwrites files with same name
rsync -av --progress "$TEMP_DIR/lessons/" "$TARGET_DIR/"

# 4️⃣ Clean up
rm -rf "$TEMP_DIR"

echo "Shared lessons updated successfully!"
