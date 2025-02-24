# DuckieTV to AppImage Converter

## Overview
A simple Bash script to convert a DuckieTV tarball (e.g., `DuckieTV-202501312102-linux-x64.tar.gz`) into an executable AppImage. It auto-detects a tarball with "duckietv" in its name, builds a versioned AppImage (e.g., `DuckieTV-202501312102-linux-x64.AppImage`), and cleans up afterward.

## Requirements
- Linux (Debian-based, Fedora-based, or Arch-based)
- Internet access (for installing `appimagetool` if missing)
- Sudo privileges (for tool installation)
- [A DuckieTV tarball](https://github.com/DuckieTV/Nightlies/releases/latest) in the same directory

## Usage
1. **Clone or Download**:

       git clone https://github.com/Sovkhoz/DuckieTV-to-AppImage.git
       cd DuckieTV-to-AppImage

 Make Executable:

        chmod +x convert.sh

Add Tarball:
        Place a tarball (e.g., DuckieTV-202501312102-linux-x64.tar.gz) in the same directory.
    Runn:
    
    ./convert.sh

Run AppImage:

    ./DuckieTV-202501312102-linux-x64.AppImage

Features

Auto-installs appimagetool for Debian (apt), Fedora (dnf), or Arch (pacman), with a GitHub fallback.
Builds a versioned, executable AppImage from the tarball’s name.
Minimal output, automatic cleanup.

Notes

Exits if no "duckietv" tarball is found.
Temporary files persist in appimage_build_<timestamp> if the build fails.

Troubleshooting

Permissions: Ensure write access to the directory.
Errors: Check console output for issues (e.g., missing libraries).
This will render nicely on GitHub with headings, bullet points, and code blocks intact. Let me know if you need adjustments!
