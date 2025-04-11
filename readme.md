# 🔗 Hardlink Media Migration Tool

<p align="center">
  <img width="700" src="https://github.com/user-attachments/assets/your-banner-image-here.png">
</p>

> *This tool was created to optimize media library (jellyfin with 'arrs app) migration across disks without duplicating large files.*

📅 **Last updated:** April 2025

## **ℹ️ About**
This project provides two Bash scripts that help manage and migrate a hardlinked media library:

1. **`count_hard_links.sh`** — Analyzes and counts hard links per file in a given directory.
2. **`relink_hard_links.sh`** — Recreates the same hard link structure on a new disk based on inode matching, preserving storage space and folder logic.

These tools are ideal for scenarios like:
- Moving large libraries (movies/series) from one disk to another.
- Rebuilding folder structures without duplicating files.

---

## **📃 Script Descriptions**

### `count_hard_links.sh`
A diagnostic script to list files and show how many hard link references each has.

#### ✅ Features:
- 📂 Recursive scan of all files in a directory
- 🔗 Highlights files with more than one hard link
- 📄 Shows files with only a single link
- 🧾 Prints a summary at the end

#### 🧪 Example Usage:
```bash
./count_hard_links.sh /mnt/usb-drive/
```

#### ✅ Output Example:
```
🔗 2 links → /mnt/usb-drive/file1.mov
📄 1 link  → /mnt/usb-drive/notes.txt
```

---

### `relink_hard_links.sh`
The main script to **recreate a hardlink-based structure** on a new disk.

#### ✅ Features:
- Matches files by inode across `Source` and hardlink folders (`Folder1`, `Folder2`)
- Ensures the structure is rebuilt without data duplication
- Emoji-rich logging for clear feedback
- Safe handling of spaces/special characters in file paths

#### 📂 Expected folder structure:
```bash
/mnt/old_disk/Source
/mnt/old_disk/Folder1
/mnt/old_disk/Folder2

/mnt/new_disk/Source   # Already copied manually ( wtih rsync or another tools...)
```

#### ▶️ How to Use:
```bash
chmod +x relink_hard_links.sh
./relink_hard_links.sh
```

#### 🧠 How it works:
- Scans `Folder1` and `Fodler2` on the old disk
- For each file, finds the matching original in `Source` by inode
- Recreates a new hard link pointing to the copied file in the new disk

---

## **📦 Technology Used**

- 🐧 **Bash** scripting
- 🔍 `find`, `stat`, `cut`, `grep`, `ln`, `mkdir`
- 🧠 Filesystem knowledge (inode usage, hard links)

---

## **🧑‍💻 Contributors:**

### **💡 Idea, Dev & Testing**
- [Simon](https://github.com/6im0n)

---

## **🛠️ Tips Before Running**
- Make sure your new `Source` is already copied to the new disk
- Both new and old structures must reside on the **same disk** for hard links to work
- Test with `count_hard_links.sh` before running the migration script

---

## **👐 Contribute**
Feel free to fork, improve logging, add dry-run modes or convert for symlinks! PRs welcome 😄
