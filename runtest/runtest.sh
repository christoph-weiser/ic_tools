#!/bin/bash
#------------------------------------------------------------
# NAME
#       runtest.sh
#
# SYNOPSIS
#       runtest.sh file [cores]
#
# DESCRIPTION
#       initiate a regression test based on 
#       the setup specified in the config file.
#
#------------------------------------------------------------

script="$IC_TOOLS/runtest/runtest.py"

file="$1"
cores="$2"
simulator="$3"

[[ -z "$1" ]] && echo "runtest.sh file [cores]" && exit

if [ -z "$2" ]; then 
    cores=1
fi

python "$script" --source="$file" --cores="$cores" --simulator=$simulator
