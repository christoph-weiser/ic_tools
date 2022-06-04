#!/usr/bin/env python3

import pya

# filename is cmdline argument

gdsfile = filename
label = prefix
outname = filename.replace(".gds", "_prefixed.gds")

layout = pya.Layout()

# Read each GDS files
layout.read(gdsfile)

for cell in layout.each_cell():
    cell.name = label + "__" + cell.name

layout.write(outname)
