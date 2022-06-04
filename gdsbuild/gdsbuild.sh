#!/bin/bash
#------------------------------------------------------------
# NAME
#       gdsbuild.sh
#
# SYNOPSIS
#       gdsbuild.sh layout cells
#
# DESCRIPTION
#       build a gds by merging a list of 
#       cells into the layout top cell. 
#       This assumes a cells input file, where
#       all cell.gds files are on a new line.
#
#------------------------------------------------------------

script="$IC_TOOLS/gdsbuild/gdsbuild.py"

filename="$1"
cellsfile="$2"

[[ -z "$2" ]] && echo "gdsbuild.sh file cells" && exit

klayout -z -r "$script" -rd filename="$filename" -rd cellsfile="$cellsfile"
