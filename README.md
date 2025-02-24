README for duckietv_to_appimage.sh
Overview
This script automatically converts a DuckieTV tarball (e.g., DuckieTV-202501312102-linux-x64.tar.gz) into an executable AppImage. It detects a tarball with "duckietv" in its name in the same directory, builds the AppImage with the tarball’s versioned filename (e.g., DuckieTV-202501312102-linux-x64.AppImage), and ensures it’s ready to run without manual setup.
Requirements

    Linux System: Tested on Debian-based (e.g., Ubuntu), Fedora-based, and Arch-based distributions.
    Internet Access: Needed if appimagetool isn’t installed (downloads it automatically).
    Sudo Privileges: Required for installing appimagetool and dependencies if not already present.
    Tarball: A file like DuckieTV-<version>.tar.gz in the same directory as the script.

Usage

    Save the Script:
        Save duckietv_to_appimage.sh to a directory (e.g., /home/user/scripts/).
    Make Executable:
    bash

chmod +x duckietv_to_appimage.sh

Place Tarball:

    Copy a DuckieTV tarball (e.g., DuckieTV-202501312102-linux-x64.tar.gz) into the same directory.

Run:
bash

./duckietv_to_appimage.sh

Output:

    An executable AppImage (e.g., DuckieTV-202501312102-linux-x64.AppImage) appears in the same directory.
    Run it directly:
    bash

        ./DuckieTV-202501312102-linux-x64.AppImage

What It Does

    Installs Tools: If appimagetool isn’t present, it installs it using apt (Debian), dnf (Fedora), or pacman (Arch), or downloads it from GitHub as a fallback.
    Finds Tarball: Locates a tarball with "duckietv" in its name.
    Builds AppImage: Extracts the tarball, packages it into an AppImage with the versioned name, and sets it as executable.
    Cleans Up: Removes temporary files.

Notes

    If no DuckieTV tarball is found, the script exits with an error.
    If the build fails, temporary files remain in $OUTPUT_DIR/appimage_build_<timestamp> for debugging.
    The AppImage includes all files from the tarball’s DuckieTV/ directory, plus README, setup, and share/ if present.

Troubleshooting

    Permission Errors: Ensure you have write access to the script’s directory.
    Missing Libraries: If the AppImage fails to run, note the error and additional dependencies may need inclusion.
