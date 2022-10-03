#!/bin/bash

# discord-patcher.sh
#
# Patches Chrome extensions into the Linux Discord client (defaults to AutoScroll).
#
# Requires: wget, unzip, asar, jq (optional)
#
# Usage: Run ./discord-patcher.sh, restart Discord if open.
#
# Notes: This is janky and might break at any given time (works as of 2022-08-15).
#        "it works on my machine," but use at your own risk.

DISCORD_CFG_DIR="$HOME/.config/discord"
# from https://chrome.google.com/webstore/detail/autoscroll/occjjkgifpmdgodlplnacmkejpdionan
EXTENSION_ID="occjjkgifpmdgodlplnacmkejpdionan"
# latest version when I wrote this, should work fine
CHROME_PRODVERSION="104.0.5112.79"

# not sure if discord clears old version dirs out, but just in case...
DISCORD_DATA_DIR=$(ls $DISCORD_CFG_DIR | grep -E '[0-9]+(\.[0-9]+){1,}' | sort -Vr)
read DISCORD_DATA_DIR __ <<< "$DISCORD_DATA_DIR"  # get first item in list
DISCORD_DATA_DIR=$DISCORD_CFG_DIR/$DISCORD_DATA_DIR/modules/discord_desktop_core
echo Found discord_desktop_core at $DISCORD_DATA_DIR...
cd $DISCORD_DATA_DIR

mkdir $EXTENSION_ID
cd $EXTENSION_ID
# https://stackoverflow.com/questions/7184793/how-to-download-a-crx-file-from-the-chrome-web-store-for-a-given-id
CRX_DOWNLOAD_LINK="https://clients2.google.com/service/update2/crx?response=redirect&prodversion=$CHROME_PRODVERSION&acceptformat=crx2,crx3&x=id%3D$EXTENSION_ID%26uc"
echo Downloading extension $EXTENSION_ID from $CRX_DOWNLOAD_LINK...
wget -q $CRX_DOWNLOAD_LINK -O $EXTENSION_ID.crx
unzip -qq $EXTENSION_ID.crx 2>/dev/null  # suppress warning about long header of crx files
rm $EXTENSION_ID.crx
if which jq >/dev/null 2>/dev/null; then
    EXTENSION_NAME=$(jq -r ".name" manifest.json)
    echo Found extension name $EXTENSION_NAME!
else
    EXTENSION_NAME=$EXTENSION_ID
    echo jq not installed, installing extension with name as $EXTENSION_ID.
fi
cd ..
mv $EXTENSION_ID $EXTENSION_NAME

mkdir tmp
echo Unpacking core.asar...
asar e core.asar tmp

echo Backing up core.asar to .core.asar.bak...
cp core.asar .core.asar.bak

echo Patching...
PATCH_AFTER="const loadMainPage = () => {"
PATCH="mainWindow.webContents.session.loadExtension(__dirname.split('core.asar')[0] + '$EXTENSION_NAME');"
sed -i "/$PATCH_AFTER/a \  $PATCH" tmp/app/mainScreen.js
asar p tmp core.asar --unpack-dir '**'
rm -r tmp
echo Done!
