#!/bin/bash

# config-h320m.sh
#
# Configures the functionality of the buttons on the Huion H320M drawing tablet.
#
# Requires: xf86 wacom input drivers, xsetwacom
#
# Usage: Specify which keyboard buttons you'd like to map to each button on the
#        tablet (see diagram below for number->button mapping info), then run
#        ./config-h320m.sh to activate your changes.
#
#                 Button number diagram:
#  | .----------------------------------------------.
# .=.|   .     __                             __    |
# |=||  (1)   |           Hex -> dec:           |   |
# |_[:  (2)               a = 10                    |
#    |  (3)               b = 11                  h |
#    |   8                c = 12                  u |::
#    | b|a|c              d = 13                  i |::
#    |   9                e = 14                  o |::
#    |  (d)               f = 15                  n |
#    |  (e)                                         |
#    |  (f)   |__     usb id = 256c:006d      __|   |
#    |                                              |
#    '----------------------------------------------'
# Note: keys should be specified by decimal value; hex values were used in the
#       diagram to make it look pretty :)

declare -A pad_binds
TABLET_PEN="HUION Huion Tablet_H320M Pen stylus"
TABLET_PAD="HUION Huion Tablet_H320M Pad pad"

pad_binds=(
     ["1"]="Esc"
     ["2"]="Tab"
     ["3"]="Shift +space"
     ["8"]="Ctrl Shift ="
     ["9"]="Ctrl -"
    ["10"]="Ctrl Shift P"
    ["11"]="Ctrl Z"
    ["12"]="Ctrl Shift Z"
    ["15"]="Alt Tab"
)

for b in "${!pad_binds[@]}"; do
    if [[ ${pad_binds["$b"]} == "MOUSE"* ]]; then
        pad_binds["$b"]=${pad_binds["$b"]#"MOUSE "}
        xsetwacom --set "$TABLET_PAD" button $b ${pad_binds["$b"]}
    else
        xsetwacom --set "$TABLET_PAD" button $b key ${pad_binds["$b"]}
    fi
done
