#!/bin/bash
#------------------------------------------------------------
# NAME
#       make.sh
#
# SYNOPSIS
#       make.sh
#
# DESCRIPTION
#       Create relative symbolic links and place them
#       without extension inside the bin directory.
#       the bin folder can then be added to PATH variable 
#       for easy tool access.
#
#------------------------------------------------------------

mkdir -p bin

for file in $(find . -name "*.sh" -type f); do
    name=$(echo "$file" | awk -F "/" '{print $NF}' | awk -F "." '{print $1}')
    ln -r -s $file bin/$name 
done


