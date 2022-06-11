#!/bin/bash
#------------------------------------------------------------
# NAME
#       labelmove.sh
#
# SYNOPSIS
#       labelmove.sh file 
#    
# DESCRIPTION
#       move all labels from label layer 
#       to pin layer for M1 to M5.
#
#------------------------------------------------------------

script="$IC_TOOLS/labelmove/labelmove.py"

filename="$1"

[[ -z "$1" ]] && echo "labelmove.sh file " && exit

klayout -z -r "$script" -rd filename="$filename"
