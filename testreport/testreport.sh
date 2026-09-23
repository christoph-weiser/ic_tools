#!/bin/bash
#------------------------------------------------------------
# NAME
#       testreport.sh
#
# SYNOPSIS
#       "testreport.sh"
#
# DESCRIPTION
#       create testreport for all tests in the
#       results directory
#
#
#------------------------------------------------------------

SCRIPT="$IC_TOOLS/testreport/testreport.py"

python3 "$SCRIPT"
