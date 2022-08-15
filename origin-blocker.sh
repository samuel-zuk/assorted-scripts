#!/bin/bash

# origin-blocker.sh
#
# Disables/enables access to Origin folders for Steam games running under Proton.
#
# Origin will try to do stuff while a game is running, which can cause lag. The
# solution myself and others have found is to not allow access to the game's
# Origin folder. However, when Origin needs to update, it will get stuck if it
# has no access. This is the reason I wrote this.
#
# Requires: games installed via Steam Proton that require Origin.
#
# Usage: see ./origin-blocker.sh --help for more.
#
# Note: if your game is not listed, add its steam id below.

declare -A OPTS_HELP
declare -A OPTS_LONG
OPTS="-h -l -b -u -s"
OPTS_LONG=(["-h"]="--help" ["-l"]="--list" ["-b"]="--block" ["-u"]="--unblock" ["-s"]="--status")
OPTS_HELP["-h"]="Display this help message."
OPTS_HELP["-l"]="Print a list of Steam games that require Origin."
OPTS_HELP["-b"]="Block write access to Origin for the specified game."
OPTS_HELP["-u"]="Unblock write access to Origin for the specified game."
OPTS_HELP["-s"]="If installed, display the Origin write access status for the specified game."

declare -A POSARGS_DESC
POSARGS="game"
POSARGS_DESC["game"]="The name of the Steam game"

DIR_PROTON_DATA="$HOME/.local/share/Steam/steamapps/compatdata"
DIR_PROGDATA="pfx/drive_c/ProgramData"
declare -A APPIDS
APPIDS["Titanfall"]="1454890"
APPIDS["Titanfall 2"]="1237970"
APPIDS["Mass Effect Legendary Edition"]="1328670"
APPIDS["Battlefield 1"]="1238840"
APPIDS["STAR WARS Battlefront II"]="1237950"
APPIDS["STAR WARS Jedi: Fallen Order"]="1172380"
APPIDS["Dragon Age: Origins"]="17450"
APPIDS["Dragon Age Inquisition"]="1222690"

echo_usage() {
    local usage="Usage: $0"
    for x in $OPTS; do usage="$usage [$x]"; done
    usage="$usage $POSARGS"
    echo $usage
}

echo_help () {
    echo_usage
    echo -e "\nAvailable options:"
    for x in $OPTS; do
        echo "  $x, ${OPTS_LONG["$x"]}: ${OPTS_HELP["$x"]}"
    done
    echo -e "\nRequired arguments:"
    for x in $POSARGS; do
        echo "  $x: ${POSARGS_DESC["$x"]}"
    done
}

list_games () {
    echo "Known games:"
    for key in "${!APPIDS[@]}"; do echo "$key"; done
}

if !([[ $1 ]]); then
    echo_usage
    echo "For more help, try $0 --help."
    exit
fi

opt=""
for x in $OPTS; do
    if [[ $x = $1 ]]; then
        opt="$x"
        break
    elif [[ ${OPTS_LONG["$x"]} = $1 ]]; then
        opt="$x"
        break
    fi
done

case "$opt" in
    "-h")
        echo_help
        exit
        ;;
    "-l")
        list_games
        exit
        ;;
    "-b"|"-u"|"-s")
        if [[ $# -eq 1 ]]; then
            echo "Error: please specify a game. For more help, try $0 --help."
            exit 1
        elif !([[ ${APPIDS["$2"]} ]]); then
            echo "Error: unknown game $2. To list known games, try $0 --list."
            exit 1
        else
            for id in $(ls $DIR_PROTON_DATA); do
                if [[ "${APPIDS["$2"]}" -eq "$id" ]]; then
                    GAMEID=$id
                fi
            done
        fi

        if !([[ $GAMEID ]]); then
            echo "Error: $2 is not installed on this system."
            exit 1
        fi

        ls -l $DIR_PROTON_DATA/$GAMEID/$DIR_PROGDATA | grep Origin | grep -q root
        OWNED_BY_USER=$?

        case "$opt" in
            "-b")
                if [[ $OWNED_BY_USER -eq 1 ]]; then
                    sudo chown -R root:root $DIR_PROTON_DATA/$GAMEID/$DIR_PROGDATA/Origin
                    if [[ $? ]]; then
                        echo "Successfully blocked Origin Client for $2."
                    else
                        echo "Unable to block Origin Client for $2." >&2
                        exit 1
                    fi
                else
                    echo "Origin Client for $2 already blocked."
                fi
                exit
                ;;
            "-u")
                if [[ $OWNED_BY_USER -eq 0 ]]; then
                    usr=$(whoami)
                    sudo chown -R $usr:$usr $DIR_PROTON_DATA/$GAMEID/$DIR_PROGDATA/Origin
                    if [[ $? ]]; then
                        echo "Successfully unblocked Origin Client for $2."
                    else
                        echo "Unable to unblock Origin Client for $2." >&2
                        exit 1
                    fi
                else
                    echo "Origin Client for $2 already unblocked."
                fi
                exit
                ;;
            "-s")
                status=""
                if [[ $OWNED_BY_USER -eq 0 ]]; then
                    status="blocked"
                else
                    status="unblocked"
                fi
                    echo "Origin Client Status for $2: $status"
                exit
                ;;
            *)
                exit
                ;;
        esac
        exit
        ;;
    *)
        echo "Error: unknown option $1. For more help, try $0 --help."
        exit 1
        ;;
esac
