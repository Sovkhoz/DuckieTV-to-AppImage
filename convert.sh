#!/bin/bash

# Set directories to script location
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
OUTPUT_DIR="$SCRIPT_DIR"
WORK_DIR="$OUTPUT_DIR/appimage_build_$(date +%s)"

# Hardcoded settings
EXEC_NAME="DuckieTV"
FULL_EXEC_PATH="DuckieTV/DuckieTV"
EXEC_BASE="DuckieTV"

# Minimal feedback
echo "Converting DuckieTV tarball to AppImage..."

# Function to install appimagetool
install_appimagetool() {
    if [ -f /etc/debian_version ]; then
        echo "Detected Debian-based system. Installing appimagetool..."
        sudo apt update && sudo apt install -y fuse libfuse2 || {
            echo "Failed to install dependencies via apt. Falling back to manual install."
            wget -q -O /tmp/appimagetool https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage || {
                echo "Failed to download appimagetool. Exiting."
                exit 1
            }
            sudo chmod +x /tmp/appimagetool
            sudo mv /tmp/appimagetool /usr/local/bin/appimagetool
        }
    elif [ -f /etc/fedora-release ] || [ -f /etc/redhat-release ]; then
        echo "Detected Fedora-based system. Installing appimagetool..."
        sudo dnf install -y fuse-libs || {
            echo "Failed to install dependencies via dnf. Falling back to manual install."
            wget -q -O /tmp/appimagetool https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage || {
                echo "Failed to download appimagetool. Exiting."
                exit 1
            }
            sudo chmod +x /tmp/appimagetool
            sudo mv /tmp/appimagetool /usr/local/bin/appimagetool
        }
    elif [ -f /etc/arch-release ]; then
        echo "Detected Arch-based system. Installing appimagetool..."
        sudo pacman -Sy --noconfirm fuse2 || {
            echo "Failed to install dependencies via pacman. Falling back to manual install."
            wget -q -O /tmp/appimagetool https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage || {
                echo "Failed to download appimagetool. Exiting."
                exit 1
            }
            sudo chmod +x /tmp/appimagetool
            sudo mv /tmp/appimagetool /usr/local/bin/appimagetool
        }
    else
        echo "Unsupported system. Attempting manual appimagetool install..."
        wget -q -O /tmp/appimagetool https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage || {
            echo "Failed to download appimagetool. Exiting."
            exit 1
        }
        sudo chmod +x /tmp/appimagetool
        sudo mv /tmp/appimagetool /usr/local/bin/appimagetool
    fi
}

# Check if appimagetool is installed
if ! command -v appimagetool >/dev/null 2>&1; then
    install_appimagetool
    if ! command -v appimagetool >/dev/null 2>&1; then
        echo "Failed to install appimagetool. Exiting."
        exit 1
    fi
fi

# Find DuckieTV tarball
TARBALL=$(find "$SCRIPT_DIR" -maxdepth 1 -type f -iname "*duckietv*.tar.gz" | head -n 1)
if [ -z "$TARBALL" ]; then
    echo "No DuckieTV tarball found in $SCRIPT_DIR. Exiting."
    exit 1
fi

# Extract versioned filename from tarball
TARBALL_BASENAME=$(basename "$TARBALL" .tar.gz)
APP_NAME_VERSIONED="$TARBALL_BASENAME"

# Create working directory
mkdir -p "$WORK_DIR/AppDir" || {
    echo "Failed to create $WORK_DIR/AppDir. Exiting."
    exit 1
}
cd "$WORK_DIR" || exit

# Extract tarball silently
tar -xf "$TARBALL" 2>/dev/null || {
    echo "Failed to extract tarball. Exiting."
    exit 1
}

# Move files into AppDir
mv "$EXEC_BASE"/* "AppDir/" 2>/dev/null || true
mv README setup share "AppDir/" 2>/dev/null || true

# Fix permissions
chmod -R u+rwX "$WORK_DIR"
chown -R "$USER:$USER" "$WORK_DIR"

# Create AppRun script
cat <<EOF > AppDir/AppRun
#!/bin/bash
HERE="\$(dirname "\$(readlink -f "\${0}")")"
exec "\$HERE/$EXEC_NAME" "\$@"
EOF
chmod +x AppDir/AppRun

# Create desktop file (using base APP_NAME for consistency)
cat <<EOF > AppDir/$APP_NAME.desktop
[Desktop Entry]
Name=$APP_NAME
Exec=$EXEC_NAME
Type=Application
Terminal=false
Icon=$APP_NAME
Categories=Utility;
EOF

# Copy icon if available
[ -f "AppDir/img/logo/icon256.png" ] && cp "AppDir/img/logo/icon256.png" "AppDir/$APP_NAME.png"

# Build AppImage with versioned name
appimagetool AppDir "$OUTPUT_DIR/$APP_NAME_VERSIONED.AppImage" 2>/dev/null || {
    echo "Build failed. Files are in $WORK_DIR."
    exit 1
}

# Clean up
cd "$OUTPUT_DIR"
rm -rf "$WORK_DIR"

echo "Done! AppImage created: $OUTPUT_DIR/$APP_NAME_VERSIONED.AppImage"
