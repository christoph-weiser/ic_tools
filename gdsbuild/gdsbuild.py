#!/usr/bin/env python3

import pya
from os import listdir
import glob

# topcell  is cmdline argument
# cellsdir is cmdline argument

layout = pya.Layout()
layout.read(topcell)

simple_cells    = glob.glob("{}/*.gds.gz".format(cellsdir))
assembled_cells = glob.glob("{}/*/*.gds.gz".format(cellsdir))

cells = simple_cells + assembled_cells

opt = pya.LoadLayoutOptions()
opt.cell_conflict_resolution = opt.CellConflictResolution.OverwriteCell

for elem in cells:
    layout.read(elem, opt)

name = topcell.split("/")[-1] 
layout.write(name)
