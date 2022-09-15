#!/bin/bash
#------------------------------------------------------------
# NAME
#       topcell.sh 
#
# SYNOPSIS
#       topcell.sh file
#
# DESCRIPTION
#       Create a top cell gds, which is a 
#       empty gds file with cell information 
#       underneath. This can be merged with
#       the actual layout cells to create
#       a complete gds.
#
#------------------------------------------------------------

script="$IC_TOOLS/topcell/topcell.py"

filename="$1"

[[ -z "$1" ]] && echo "topcell.sh file" && exit

klayout -z -r "$script" -rd filename="$filename"
