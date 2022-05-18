#!/bin/bash
#------------------------------------------------------------
# NAME
#       merge.sh
#
# SYNOPSIS
#       merge.sh file_a file_b
#
# DESCRIPTION
#       use klayout to merge to gds files
#
#------------------------------------------------------------

script="$IC_TOOLS/merge/merge.py"

filename_a="$1"
filename_b="$2"

[[ -z "$2" ]] && echo "merge.sh file_a file_b" && exit

klayout -z -r "$script" -rd filename_a="$filename_a" -rd filename_b="$filename_b"
