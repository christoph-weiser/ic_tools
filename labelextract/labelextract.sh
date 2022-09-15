#!/bin/bash
#------------------------------------------------------------
# NAME
#       labelextract.sh
#
# SYNOPSIS
#       labelextract.sh file
#
# DESCRIPTION
#       use klayout to extract the top-level labels of 
#       the input file.
#      
#
#------------------------------------------------------------

script="$IC_TOOLS/labelextract/labelextract.py"
filename="$1"

[[ -z "$1" ]] && echo "labelextract.sh file" && exit

klayout -z -r "$script" -rd filename="$filename"
