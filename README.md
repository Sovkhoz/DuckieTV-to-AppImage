# DuckieTV AppImage Builder (CachyOS Edition)

Easily build and launch the latest **DuckieTV AppImage** on CachyOS with a single command.

## 🔧 What It Does

- 🧠 **Auto-detects and downloads** the latest `linux-x64` nightly release from GitHub  
- 📦 **Auto-extracts and packages** the app into an AppImage  
- 🧰 **Auto-installs dependencies** (via `paru`) — zero manual setup  
- 🖥️ **Auto-creates or updates a desktop shortcut** (`~/Desktop/DuckieTV.desktop`)  
- 🔁 **Auto-skips re-downloads** if archive already exists  
- 🧹 **Auto-cleans up** temporary files (unless `--keep-work` is used)

## 🚀 Usage

```bash
chmod +x convert.sh
./convert.sh
```

You’ll get a working DuckieTV AppImage in under a minute — no manual extraction, no desktop tweaking, no config hassles.

### Optional flags

- `--tarball /path/to/archive` — Use a local `.zip` or `.tar.gz` instead  
- `--output /path/to/dir` — Change where the AppImage is saved  
- `--keep-work` — Keep temporary build files

## ✅ Requirements

- CachyOS with `paru` installed (script handles the rest)

---

**One command. Zero setup. Always up to date.**  
```bash
./convert.sh
```
