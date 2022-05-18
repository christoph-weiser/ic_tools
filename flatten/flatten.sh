#!/bin/bash
#------------------------------------------------------------
# NAME
#       flatten.sh
#
# SYNOPSIS
#       flatten.sh file
#
# DESCRIPTION
#       use klayout to flatten the layout
#
#------------------------------------------------------------

script="$IC_TOOLS/flatten/flatten.py"
filename="$1"

[[ -z "$1" ]] && echo "flatten.sh file" && exit

klayout -z -r "$script" -rd filename="$filename"
