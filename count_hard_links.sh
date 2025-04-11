#!/bin/bash

TARGET_DIR="$1"

if [[ -z "$TARGET_DIR" || ! -d "$TARGET_DIR" ]]; then
    echo "❗ Please provide a valid folder path."
    echo "Usage: $0 /path/to/folder"
    exit 1
fi

echo "🔍 Counting hard link references in: $TARGET_DIR"
echo

# Use stat with | as separator to avoid cutting paths
find "$TARGET_DIR" -type f -print0 | while IFS= read -r -d '' file; do
    info=$(stat -c '%h|%n' "$file" 2>/dev/null)
    if [[ -n "$info" ]]; then
        links=$(echo "$info" | cut -d'|' -f1)
        path=$(echo "$info" | cut -d'|' -f2-)

        if (( links > 1 )); then
            echo "🔗 $links links → $path"
        else
            echo "📄 $links link  → $path"
        fi
    fi
done
