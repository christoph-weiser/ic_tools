#!/usr/bin/env python3

import pya

# filename is cmdline argument

gdsfile = filename
outname = filename.replace(".gds", "_top.gds")

layout = pya.Layout()
layout.read(gdsfile)

cells = [x for x in layout.top_cell().each_child_cell()]

for cell in cells:
    layout.prune_subcells(cell, -1)
    layout.cell(cell).clear()

layout.write(outname)
