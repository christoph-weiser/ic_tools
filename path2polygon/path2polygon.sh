#!/bin/bash
#------------------------------------------------------------
# NAME
#       path2polygon.sh
#
# SYNOPSIS
#       path2polygon.sh file
#
# DESCRIPTION
#       use klayout to convert all path to polygon in 
#       a hierachical or flat gds.
#
#------------------------------------------------------------

script="$IC_TOOLS/path2polygon/path2polygon.py"
filename="$1"

[[ -z "$1" ]] && echo "path2polygon.sh file" && exit

klayout -z -r "$script" -rd filename="$filename"
