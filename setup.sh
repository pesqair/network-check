#! /bin/bash

# Copyright (c) 2022 HudsonOnHere
# This software is provided "as-is", with no warranties or guarantees of any kind


readonly arg="${1}"
readonly FILE=/Users/Shared/network_autoswitcher.sh
readonly SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
readonly version="0.1"


err() {

    echo "$*" >&2
}


usage() {

    echo "Network AutoSwitcher Setup Tool, Version: $version"
    echo
    echo "USAGE: $0 [flag...] (-h|-i|-u)"
    echo
    echo "      -h | --help         Print this message"
    echo "      -i | --install      Install"
    echo "      -u | --uninstall    Uninstall"
    echo

}


checkInstalled() {

    if test -f "$FILE"; then
        return 1

    elif test ! -f "$FILE"; then
        return 0

    else
        err "ERROR: Unhandled exception occured"
        exit 1

    fi
}


install() {

    if checkInstalled; then
      
        cd $SCRIPT_DIR && cp network_autoswitcher.sh $FILE
        launchctl load local.network_autoswitcher.plist
        launchctl start local.network_autoswitcher.plist
        echo "$0: network_autoswitcher.sh has been installed to $FILE successfully."
        exit 0


    elif ! checkInstalled; then

        err "$0: ERROR: network_autoswitcher.sh is already installed at $FILE"
        exit 1

    fi
}


uninstall() {

    if ! checkInstalled; then

        rm -i $FILE
        launchctl stop local.network_autoswitcher.plist
        launchctl unload local.network_autoswitcher.plist
        echo "$0: network_autoswitcher.sh has been uninstalled successfully."
        exit 0

    elif checkInstalled; then

        err "$0: ERROR: network_autoswitcher.sh is not installed, nothing to uninstall."
        exit 1

    fi
}


validateArg() {

    # Ensures at least 1 argument has been passed

    if [[ -z "${arg}" ]]; then
    
        echo "$0: Invalid argument, run '$0 --help' to see example usage."
        echo
        err "ERROR: $0 expected at least 1 argument, but $# were given."
        exit 1

    fi
}


main() {

    validateArg

    case "${arg}" in

        -h | --help)
            usage
            exit 0
            ;;
        
        -i | --install)
            install
            ;;
        
        -u | --uninstall)
            uninstall
            ;;
        
        *)
            echo "$0: Invalid argument '${arg}', see usage for available commands."
            echo
            err "ERROR: Unrecognized command '${arg}', run '$0 --help' for help."
            exit 1
            ;;

    esac
}

main "${@}"