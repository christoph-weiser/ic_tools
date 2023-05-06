#!/bin/bash
#------------------------------------------------------------
# NAME
#       xor.sh
#
# SYNOPSIS
#       xor.sh file_a file_b
#
# DESCRIPTION
#       use klayout to calculate xor of two files
#
#------------------------------------------------------------

script="$IC_TOOLS/xor/xor.drc"

filename_a="$1"
filename_b="$2"
outname="xor.gds"

[[ -z "$2" ]] && echo "xor.sh file_a file_b" && exit

klayout -zz -r "$script" -rd filename_a="$filename_a" -rd filename_b="$filename_b" -rd outname="$outname"
