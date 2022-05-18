#!/bin/bash
#------------------------------------------------------------
# NAME
#       drc.sh
#
# SYNOPSIS
#       drc.sh file topcell
#
# DESCRIPTION
#       run drc check on the specified file.
#       This needs to be run on a flat gds
#       file to work properly.
#
#------------------------------------------------------------

filename="$1"
topcell="$2"

[[ -z "$1" ]] || [[ -z "$2" ]] && echo "drc.sh file topcell" && exit

magic -noconsole << EOF
gds read $filename
load $topcell
select top cell
expand
drc catchup
drc why
EOF
