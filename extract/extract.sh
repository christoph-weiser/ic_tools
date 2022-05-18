#!/bin/bash
#------------------------------------------------------------
# NAME
#       extract.sh
#
# SYNOPSIS
#       extract.sh gdsfile topcell
#
# DESCRIPTION
#       extract a netlist from a flat gds file that 
#       can be used to perform lvs.
#
#------------------------------------------------------------

DIRNAME="ext"

gdsfile="$1"
topcell="$2"


[[ -z "$gdsfile" ]] || [[ -z "$topcell" ]] \
&& echo "Usage: extract.sh gdsfile topcell" && exit 0

if [ -d "$DIRNAME" ]; then
    rm -r "$DIRNAME"
fi
mkdir "$DIRNAME"

cd "$DIRNAME"

magic -dnull -noconsole << EOF
gds read "../$gdsfile"
load $topcell
select top cell
select flat
extract all
ext2spice hierarchy on
ext2spice scale off
ext2spice cthresh infinite
ext2spice
quit -noprompt
EOF
