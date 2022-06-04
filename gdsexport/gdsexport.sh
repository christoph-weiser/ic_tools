#!/bin/bash
#------------------------------------------------------------
# NAME
#       gdsexport.sh
#
# SYNOPSIS
#       gdsexport.sh file
#
# DESCRIPTION
#       export all cells from a gds layout file
#       to individual gds files.
#
#------------------------------------------------------------

filename="$1"
script="$IC_TOOLS/gdsexport/gdsexport.py"

[[ -z "$1" ]] && echo "gdsexport.sh file" && exit

mkdir -p blocks
klayout -z -r "$script" -rd filename="$filename"
