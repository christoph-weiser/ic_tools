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

# RC Pex
magic -dnull -noconsole << EOF
gds read "../$gdsfile"
load $topcell
select top cell
flatten $topcell
load $topcell
extract all
ext2sim labels on
ext2sim
extresist tolerance 10
extresist
ext2spice lvs
ext2spice cthresh 1
ext2spice extresist on
ext2spice
EOF

# CC Pex
# magic -dnull -noconsole << EOF
# gds read "../$gdsfile"
# load $topcell
# select top cell
# extract all
# ext2spice format ngspice
# ext2spice scale off
# ext2spice
# quit -noprompt
# EOF
