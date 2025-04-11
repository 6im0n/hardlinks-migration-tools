#!/bin/bash

OLD_DISK="/mnt/old_disk"
NEW_DISK="/mnt/new_disk"
SOURCE_DIR="$NEW_DISK/Source"

# Folders containing the original hard links
LINK_DIRS=("Folder1" "Folder2")

echo "🔁 Starting relink process from $OLD_DISK to $NEW_DISK..."
echo

for dir in "${LINK_DIRS[@]}"; do
    echo "📂 Processing '$dir'..."

    find "$OLD_DISK/$dir" -type f -print0 | while IFS= read -r -d '' old_link; do
        info=$(stat -c '%i|%n' "$old_link" 2>/dev/null)
        if [[ -z "$info" ]]; then
            echo "❌ Failed to get inode for: $old_link"
            continue
        fi

        inode=$(echo "$info" | cut -d'|' -f1)

        # Find original file in Source with same inode (null-safe, no bash warning)
        original_file=""
        while IFS= read -r -d '' match; do
            original_file="${match#*|}"
            break
        done < <(find "$OLD_DISK/Source" -type f -printf '%i|%p\0' 2>/dev/null | grep -z "^$inode|")

        if [[ -z "$original_file" ]]; then
            echo "🚫 No source file found in Source for: $old_link (inode $inode)"
            continue
        fi

        relative_path="${old_link#$OLD_DISK/}"
        new_link_path="$NEW_DISK/$relative_path"
        new_target="$SOURCE_DIR/${original_file#$OLD_DISK/Source/}"

        # Ensure target file exists
        if [[ ! -f "$new_target" ]]; then
            echo "⚠️ Target file missing: $new_target"
            continue
        fi

        # Ensure destination folder exists
        mkdir -p "$(dirname "$new_link_path")" || {
            echo "❌ Failed to create directory: $(dirname "$new_link_path")"
            continue
        }

        # Create the hard link
        if ln "$new_target" "$new_link_path" 2>/dev/null; then
            echo "✅ Linked: $new_target ➡️ $new_link_path"
        else
            echo "❌ Failed to link: $new_target ➡️ $new_link_path"
        fi
    done

    echo
done

echo "🎉 Relinking complete!"
