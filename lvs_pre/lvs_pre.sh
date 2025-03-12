#!/bin/bash
#-----------------------------------------------------------
#
# SYNOPSIS:
#       lvs_pre.sh netlist.spice
#
# 
# DESCRIPTION
#       Preprocess a Klayout netlist into a more 
#       standarized format.
#
#-----------------------------------------------------------

netlist="$1"

if [ -z "$netlist" ]; then
    echo "lvs_pre.sh netlist.spice"
else
    python "$IC_TOOLS/lvs_pre/lvs_pre.py" --source "$netlist" 
fi
