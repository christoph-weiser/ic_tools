#!/usr/bin/env python3

import pya
from os import listdir

# topcell  is cmdline argument
# cellsdir is cmdline argument

layout = pya.Layout()
layout.read(topcell)

cells = listdir(cellsdir)

opt = pya.LoadLayoutOptions()
opt.cell_conflict_resolution = opt.CellConflictResolution.OverwriteCell

for elem in cells:
    if elem:
        if (elem[0] != "#"):
            # print(opt.CellConflictResolution)
            path = "{}/{}".format(cellsdir, elem)
            layout.read(path, opt)

name = topcell.split("/")[-1] 
layout.write(name)
