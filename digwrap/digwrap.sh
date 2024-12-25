#!/bin/bash
#------------------------------------------------------------
# NAME
#       digwrap.sh
#
# SYNOPSIS
#       digwrap.sh file
#
# DESCRIPTION
#       create a wrapper around a digital module
#
#------------------------------------------------------------

netlist="$1"

if [ -z "$netlist" ]; then
    echo "digwrap.sh netlist.spice"
else
    python "$IC_TOOLS/digwrap/digwrap.py" --source "$netlist" 
fi
