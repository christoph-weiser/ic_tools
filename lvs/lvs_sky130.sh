#!/bin/bash
#------------------------------------------------------------
# NAME
#       lvs.sh
#
# SYNOPSIS
#       lvs.sh file_a file_b
#
# DESCRIPTION
#       perform lvs using netgen between two spice
#       files.
#
#------------------------------------------------------------

file_a="$1"
file_b="$2"

[[ -z "$file_a" ]] || [[ -z "$file_b" ]] \
&& echo "Usage: lvs.sh file_a file_b" && exit 0

netgen -batch lvs "$file_a" "$file_b" "$IC_TOOLS/lvs/sky130_setup.tcl"

