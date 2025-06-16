#!/usr/bin/env bash

# DuckieTV AppImage Builder — CachyOS Edition (Nightlies, x64 only)

set -euo pipefail

# === CONFIG ===
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
TARBALL=""
OUTPUT_DIR="$SCRIPT_DIR"
KEEP_WORK=false
GITHUB_API="https://api.github.com/repos/DuckieTV/Nightlies/releases/latest"

EXEC_NAME="DuckieTV"
EXEC_BASE="DuckieTV"

# === CLI FLAGS ===
while [[ $# -gt 0 ]]; do
    case "$1" in
        --tarball) TARBALL="$2"; shift 2 ;;
        --output) OUTPUT_DIR="$2"; shift 2 ;;
        --keep-work) KEEP_WORK=true; shift ;;
        *) echo "Unknown option: $1" && exit 1 ;;
    esac
done

echo "[INFO] DuckieTV AppImage build starting..."
echo "[INFO] Output directory: $OUTPUT_DIR"

# === DEPENDENCIES ===
REQUIRED_PKGS=(fuse2 appimagetool jq wget unzip tar)
for pkg in "${REQUIRED_PKGS[@]}"; do
    if ! pacman -Q "$pkg" &>/dev/null; then
        echo "[INFO] Installing missing package: $pkg"
        paru -S --noconfirm "$pkg"
    fi
done

# === DOWNLOAD FROM GITHUB IF NONE PROVIDED ===
if [[ -z "$TARBALL" ]]; then
    echo "[INFO] No tarball provided. Searching GitHub Nightlies for linux-x64..."
    ASSET_URL=$(curl -s "$GITHUB_API" | jq -r '.assets[].browser_download_url' | grep -i 'linux' | grep -i 'x64' | grep -Ei '\.tar\.gz$|\.zip$' | head -n1)

    if [[ -z "$ASSET_URL" ]]; then
        echo "[ERROR] No compatible linux-x64 .zip or .tar.gz asset found in latest Nightly release."
        exit 1
    fi

    TARBALL="$SCRIPT_DIR/$(basename "$ASSET_URL")"
    echo "[INFO] Downloading: $ASSET_URL"
    wget -q --show-progress -O "$TARBALL" "$ASSET_URL"
fi

[[ ! -f "$TARBALL" ]] && echo "[ERROR] File not found: $TARBALL" && exit 1

EXT="${TARBALL##*.}"
BASENAME="$(basename "$TARBALL" .tar.gz | sed 's/.zip$//')"
APP_NAME_VERSIONED="$BASENAME"
WORK_DIR="$OUTPUT_DIR/appimage_build_$(date +%s)"
mkdir -p "$WORK_DIR/AppDir"

cd "$WORK_DIR"

# === EXTRACT ===
if [[ "$EXT" == "gz" ]]; then
    tar -xf "$TARBALL"
elif [[ "$EXT" == "zip" ]]; then
    unzip -q "$TARBALL"
else
    echo "[ERROR] Unsupported archive format: $EXT"
    exit 1
fi

# === ARRANGE FILES ===
mv "$EXEC_BASE"/* AppDir/ 2>/dev/null || true
mv README setup share AppDir/ 2>/dev/null || true

# === AppRun ===
cat <<EOF > AppDir/AppRun
#!/bin/bash
HERE="\$(dirname "\$(readlink -f "\$0")")"
exec "\$HERE/$EXEC_NAME" "\$@"
EOF
chmod +x AppDir/AppRun

# === .desktop file ===
cat <<EOF > AppDir/$EXEC_NAME.desktop
[Desktop Entry]
Name=$EXEC_NAME
Exec=$EXEC_NAME
Type=Application
Terminal=false
Icon=$EXEC_NAME
Categories=Utility;
EOF

# === Icon ===
[ -f "AppDir/img/logo/icon256.png" ] && cp "AppDir/img/logo/icon256.png" "AppDir/$EXEC_NAME.png"

# === Build AppImage ===
echo "[INFO] Building AppImage..."
ARCH=x86_64 appimagetool AppDir "$OUTPUT_DIR/$APP_NAME_VERSIONED.AppImage" || {
    echo "[ERROR] Build failed."
    $KEEP_WORK || rm -rf "$WORK_DIR"
    exit 1
}

echo "[SUCCESS] AppImage created: $OUTPUT_DIR/$APP_NAME_VERSIONED.AppImage"

# === Cleanup ===
$KEEP_WORK || rm -rf "$WORK_DIR"
