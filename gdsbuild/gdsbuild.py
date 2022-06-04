#!/usr/bin/env python3

import pya

# filename  is cmdline argument
# cellsfile is cmdline argument

with open(cellsfile, "r") as ifile:
    cells = ifile.read()

cells = cells.split("\n")[0:-1] # ignore last newline 

layout = pya.Layout()
layout.read(filename)

opt = pya.LoadLayoutOptions()
opt.cell_conflict_resolution = opt.CellConflictResolution.OverwriteCell

for elem in cells:
    if elem:
        if (elem[0] != "#"):
            # print(opt.CellConflictResolution)
            layout.read(elem, opt)

name = filename.split("/")[-1] 
outname = name.replace("_top", "")
layout.write(outname)
