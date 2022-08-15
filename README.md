# assorted-scripts
Scripts I wrote to do some very specific function at one point or another.

# The scripts:

### blahaj.sh
Gets the stock level of BLAHAJ (or any item) at any IKEA store (defaults to
Stoughton, MA)

Requires: jq, curl

Usage: ./blahaj.sh

### config-h320m.sh
Configures the functionality of the buttons on the Huion H320M drawing tablet.

Requires: xf86 wacom input drivers, xsetwacom

Usage: Specify which keyboard buttons you'd like to map to each button on the
tablet (see diagram in the file for number->button mapping info), then run
./config-h320m.sh to activate your changes.

### discord-patcher.sh
Patches Chrome extensions into the Linux Discord client (defaults to AutoScroll).

Requires: wget, unzip, asar, jq (optional)

Usage: Run ./discord_patcher.sh, restart Discord if open.

Notes: This is janky and might break at any given time (works as of 2022-08-15).
"it works on my machine," but use at your own risk.

### origin-blocker.sh
Disables/enables access to Origin folders for Steam games running under Proton.

Origin will try to do stuff while a game is running, which can cause lag. The
solution myself and others have found is to not allow access to the game's
Origin folder. However, when Origin needs to update, it will get stuck if it
has no access. This is the reason I wrote this.

Requires: games installed via Steam Proton that require Origin.

Usage: see ./origin-blocker.sh --help for more.

Note: if your game is not listed, add its steam id in the script. 
