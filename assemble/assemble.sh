#!/bin/bash
#------------------------------------------------------------
# NAME
#       assemble.sh
#
# SYNOPSIS
#       assemble.sh file.gds
#
# DESCRIPTION
#       prepare gds file for spice netlist extraction 
#       that can be used for LVS using netgen.
#       This assumes the TOP cell has the same name 
#       as the input filename.
#
#------------------------------------------------------------

if [ -z "$1" ]; then 
    echo "Usage: assemble file.gds"
else
    filename="$1"
    name="${filename%.*}"

    # assemble the gds
    echo "Extracting labels from GDS"
    labelextract "$filename"
    echo "Removing labels from GDS"
    labelremove "$filename"
    
    echo "Merging extracted and removed GDS files"
    merge "$name"_nolab.gds "$name"_labels.gds
    echo "flatten merged GDS file"
    flatten merged.gds
    echo "Extract spice netlist from merged flat GDS"
    extract merged_flat.gds "$name"
    
    echo "Preparing netlist"
    #modify the netlist
    sky130_pnp_mod ./ext/"$name".spice
    sed -i 's/\[/_/g;s/\]/_/g' ./ext/"$name".spice
fi
