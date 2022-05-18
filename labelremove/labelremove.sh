#!/bin/bash
#------------------------------------------------------------
# NAME
#       labelremove.sh
#       
#
# SYNOPSIS
#       labelremove.sh file
#       
# DESCRIPTION
#       use klayout to remove pins/labels hierachical
#       layout.
#
#------------------------------------------------------------

script="$IC_TOOLS/labelremove/labelremove.py"
filename="$1"

[[ -z "$1" ]] && echo "labelremove.sh file" && exit

klayout -z -r "$script" -rd filename="$filename"
