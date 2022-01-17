#!/bin/bash
# UPDATED SCRIPT FOR PEOPLE WITH WINE ISSUES
# Chromebook Linux script for the unofficial but native Linux Habbo client (LilithRainbows/HabboFlash).

# Determine architecture
ARCH=`dpkg --print-architecture`
if [ $ARCH = 'amd64' ]; then
	ZIP='HabboFlash_Release3_Linux_x64';
elif [ $ARCH = 'arm64' ]; then
	ZIP='HabboFlash_Release3_Linux_ARM64';
elif [ $ARCH = 'arm32' ]; then
	ZIP='HabboFlash_Release3_Linux_ARM32';
fi

# Install dependency
sudo apt -y update
sudo apt install -y libnss3-dev

# Download the zip from Github.
wget https://github.com/LilithRainbows/HabboFlash/releases/download/release3/$ZIP.zip

# Unpack zip and place desktop icon
unzip $ZIP.zip
sudo chmod +x "$HOME/$ZIP/HabboFlash"

mkdir -p "$HOME/.local/share/applications/HabboLinux"
wget "https://raw.githubusercontent.com/belieb/HabboFlashLinux/main/HabboLinux.desktop" -O "$HOME/.local/share/applications/HabboLinux/HabboLinux.desktop"
sudo chmod +x "$HOME/.local/share/applications/HabboLinux/HabboLinux.desktop"

sudo mkdir -p "/usr/share/icons/HabboLinux"
sudo wget "https://raw.githubusercontent.com/LilithRainbows/HabboFlash/main/HabboFlash/AppIcon.ico" -O "/usr/share/icons/HabboLinux/AppIcon.png"

# Remove zip
rm $ZIP.zip

# Installation script finished.
echo "Client installation finished. A shortcut for HabboLinux will appear on your Chromebook."

# Optional: open client after install
# "$HOME/$ZIP/HabboFlash"

# Optional: remove this installation script.
rm $0