# DuckieTV to AppImage Converter

## What’s This Thing?
This script is your shortcut to turn a DuckieTV tarball into a clickable AppImage for your Linux box. Drop a file, run the script, and bam—DuckieTV’s ready to roll! No more dicking around setting permissions because the installer messed up, no more looking for a gconf2 package for your distro. No more secretly being jealous of Debian based systems for having a .deb installer. Now you can use DuckieTV on Arch and Fedora too. 

## Stuff You Need
- A Linux setup (Ubuntu, Fedora, Arch—whatever you’ve got)
- Internet (for grabbing files or tools)
- Maybe a sudo password (if the script needs to set stuff up)
- A DuckieTV tarball (we’ll get it together)

## How to Make It Happen
1. **Grab the Script**:
   - Hit that green "Code" button up top, then click "Download ZIP".
   - Unzip it to a folder on your Desktop—call it `DuckieTV-Maker` or whatever.

2. **Score the DuckieTV File**:
   - Fire up your browser and cruise to [DuckieTV Nightly Releases](https://github.com/DuckieTV/Nightlies/releases/latest).
   - Click "Download" to grab a file like `DuckieTV-202501312102-linux-x64.tar.gz`.
   - Toss it into your `DuckieTV-Maker` folder, right next to `convert.sh`.

3. **Pop Open Terminal**:
   - Search your computer for "Terminal" and open it.

4. **Kick Things Off**:
   - In Terminal, type:
     ```bash
     cd ~/Desktop/DuckieTV-Maker
     ```
     Hit Enter.
   - Then type:
     ```bash
     chmod +x convert.sh
     ```
     Hit Enter again.

5. **Run the Magic**:
   - Type:
     ```bash
     ./convert.sh
     ```
     Hit Enter and chill. It might ask for a password to install a tool—just type it in.

6. **Launch It**:
   - Check your `DuckieTV-Maker` folder for something like `DuckieTV-202501312102-linux-x64.AppImage`.
   - Double-click it, or type in Terminal:
     ```bash
     ./DuckieTV-202501312102-linux-x64.AppImage
     ```
     Hit Enter—DuckieTV’s live!

## What’s Going On
- Finds your DuckieTV file automatically.
- Spits out an AppImage with the same name (like `DuckieTV-202501312102-linux-x64.AppImage`).
- Cleans up the mess when it’s done.

## If It Flops
- **Missing File?**: Make sure that DuckieTV tarball’s in the `DuckieTV-Maker` folder.
- **Weird Messages?**: Peek at Terminal. If it’s gibberish, Google it or ask a buddy.

Have a blast with DuckieTV!
