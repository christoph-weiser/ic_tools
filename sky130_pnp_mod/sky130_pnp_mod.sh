#!/bin/bash
#------------------------------------------------------------
# NAME
#       sky130_pnp_mod.sh
#
# SYNOPSIS
#       sky130_pnp_mod.sh netlist
#
# DESCRIPTION
#       modify extracted pnp netlists to fit into the
#       sky130 spice model subcircuit.
#
#------------------------------------------------------------

if [ -z "$1" ]; then 
    echo "Usage: sky130_pnp_mod netlist"
    exit 0
else
    netlist="$1"
    sed -i 's/sky130_fd_pr__pnp_05v0/sky130_fd_pr__pnp_05v5_W0p68L0p68/g' "$netlist" 
    awk -i inplace '{if ($0 ~ /sky130_fd_pr__pnp_05v5_W0p68L0p68/) {print $1,$3,$4,$2,$3,$5,$6} else {print $0}}' "$netlist"
fi
