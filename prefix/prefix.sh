#!/bin/bash
#------------------------------------------------------------
# NAME
#       prefix.sh
#
# SYNOPSIS
#       prefix.sh prefix file
#
# DESCRIPTION
#       use klayout to prefix all cells in gds
#
#------------------------------------------------------------

script="$IC_TOOLS/prefix/prefix.py"

prefix="$1"
filename="$2"

[[ -z "$2" ]] && echo "prefix.sh prefix file" && exit

$HOME/Programme/klayout/klayout -z -r "$script" -rd prefix="$prefix" -rd filename="$filename"
