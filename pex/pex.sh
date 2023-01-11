#!/bin/bash
#------------------------------------------------------------
# NAME
#       pex.sh
#
# SYNOPSIS
#       pex.sh gdsfile topcell
#
# DESCRIPTION
#       extract a netlist from flat gds that can 
#       be used to perform pex simulation.
#
#       This is not fully automated you need to wrap
#       a subcircuit definition including the right
#       port order around the extract.
#
#------------------------------------------------------------

DIRNAME="ext"

gdsfile="$1"
topcell="$2"


[[ -z "$gdsfile" ]] || [[ -z "$topcell" ]] \
&& echo "Usage: lvs.sh gdsfile topcell" && exit 0

if [ -d "$DIRNAME" ]; then
    rm -r "$DIRNAME"
fi
mkdir "$DIRNAME"

cd "$DIRNAME"

magic -dnull -noconsole << EOF
gds read "../$gdsfile"
load $topcell
select top cell
extract all
ext2spice format ngspice
ext2spice scale off
ext2spice
quit -noprompt
EOF

# ext2spice subcircuit on
# ext2spice subcircuit top off
# ext2spice hierarchy on
