#!/bin/bash
#------------------------------------------------------------
# NAME
#       runtest.sh
#
# SYNOPSIS
#       "runtest.sh configfile [cores] [simulator] [netlist]
#
# DESCRIPTION
#       initiate a regression test based on 
#       the setup specified in the config file.
#
#       -c,--configfile=file
#           The mandatory configuration file
#
#       --cores=n
#           The number of physical cores to use
#
#       --simulator=simulator
#           The simulator to run the tests.
#
#       --netlist=netlist
#           Netlist to use as base for tests, if 
#           not the the by default associated 
#           xschem schematic should be used.
#
#       --dryrun
#           Do not run simulation only output the
#           cases to be run and logging information.
#
#------------------------------------------------------------

SCRIPT="$IC_TOOLS/runtest/runtest.py"
CONFIG=""
CORES=""
SIMULATOR=""
NETLIST=""
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -c=*|--configfile=*)
            CONFIG=$(realpath "${1#*=}")
            shift 1
            ;;
        -c|--configfile)
            CONFIG="$(realpath "$2")"
            shift 2
            ;;
        --cores=*)
            CORES="${1#*=}"
            shift 1
            ;;
        --dryrun)
            DRYRUN=true
            shift 1
            ;;
        --simulator=*)
            SIMULATOR="${1#*=}"
            shift 1
            ;;
        --netlist=*)
            NETLIST=$(realpath "${1#*=}")
            shift 1
            ;;
        *)
            # Save unknown arguments (like the first position config)
            POSITIONAL_ARGS+=("$1")
            shift 1
            ;;
    esac
done

if [[ -z "$CONFIG" && ${#POSITIONAL_ARGS[@]} -gt 0 ]]; then
    CONFIG=$(realpath "${POSITIONAL_ARGS[0]}")
fi

if [[ -z "$CONFIG" ]]; then
    echo "runtest.sh configfile [cores] [simulator] [netlist] [dryrun]" && exit
    exit 1
fi

PYTHON_ARGS=(
    --configfile="$CONFIG"
    --cores="$CORES"
    --simulator="$SIMULATOR"
    --netlist="$NETLIST"
)

if [ "$DRYRUN" = true ]; then
    PYTHON_ARGS+=(--dryrun)
fi

python "$SCRIPT" "${PYTHON_ARGS[@]}"
