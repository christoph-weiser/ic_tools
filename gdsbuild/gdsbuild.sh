#!/bin/bash
#------------------------------------------------------------
# NAME
#       gdsbuild.sh
#
# SYNOPSIS
#       gdsbuild.sh layout cells
#
# DESCRIPTION
#       build a gds by merging cells 
#       found in the cells directory,
#       into the layout top cell. 
#
#------------------------------------------------------------

script="$IC_TOOLS/gdsbuild/gdsbuild.py"

topcell="$1"
cells="$2"

[[ -z "$2" ]] && echo "gdsbuild.sh file cells" && exit

klayout -z -r "$script" -rd topcell="$topcell" -rd cellsdir="$cells"
