#!/bin/bash

# If client installed before, remove old version.
if [ -d "$HOME/.wine/drive_c/Program Files (x86)/Sulake" ]; then
	rm -R "$HOME/.wine/drive_c/Program Files (x86)/Sulake"
	rm "$HOME/.local/share/applications/wine/Programs/Sulake/Habbo.desktop"
	echo "Reinstalling Habbo Flash client..."
  else
	echo "Installing Habbo Flash client..."
fi

# Start with installing wine, but only if .wine directory doens't exist. Using version 6.0.0, since 6.0.1 broke the client.
if [ ! -d "$HOME/.wine" ]; then
	sudo dpkg --add-architecture i386 && wget -nc https://dl.winehq.org/wine-builds/winehq.key && sudo apt-key add winehq.key && echo "deb https://dl.winehq.org/wine-builds/debian/ buster main" | sudo tee /etc/apt/sources.list.d/wine.list && echo "deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10 ./" | sudo tee /etc/apt/sources.list.d/winehq.list && sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DFA175A75104960E && sudo apt update && sudo apt install -y --install-recommends winehq-stable=6.0.0~buster-1 wine-stable=6.0.0~buster-1 wine-stable-amd64=6.0.0~buster-1 wine-stable-i386=6.0.0~buster-1

	wineboot --init
	wineserver -k
fi

# Install package jq if not installed, to parse JSON file.
if ! type "jq" > /dev/null; then
	sudo apt-get update
	sudo apt-get -y install jq
fi

# Get url for latest flash client from habbo.com. I prefer to do this with curl -s, but "wget -cq -O -" doesn't need additional packages installed.
clienturl=`wget -cq https://www.habbo.com/gamedata/clienturls -O - | jq --raw-output '."flash-windows"'`

# Download the zip from Habbo's servers.
wget "$clienturl"

# Unpack zip and place desktop icon (aka installing but without .NET installer)
mkdir -p "$HOME/.wine/drive_c/Program Files (x86)/Sulake/HabboFlash"
mkdir -p "$HOME/.local/share/applications/wine/Programs/Sulake"

unzip -o HabboWin.zip -d "$HOME/.wine/drive_c/Program Files (x86)/Sulake/HabboFlash/"
wget "https://raw.githubusercontent.com/belieb/HabboFlashLinux/main/Habbo.desktop" -O "$HOME/.local/share/applications/wine/Programs/Sulake/Habbo.desktop"
sudo mkdir -p "/usr/share/icons/Habbo" && sudo cp ".wine/drive_c/Program Files (x86)/Sulake/HabboFlash/icon48.png" "/usr/share/icons/Habbo/icon48.png"

rm HabboWin.zip

# Installation script finished.
echo "Habbo Flash installation finished. A shortcut will appear on your Chromebook. Opening the first time/after reboots may take some time. Run this script again to update the client (sh HabboFlashInstall.sh)."

# Optional: open client after install
# wine "$HOME/.wine/drive_c/Program Files (x86)/Sulake/HabboFlash/Habbo.exe"

# Optional: remove this installation script.
# rm $0
