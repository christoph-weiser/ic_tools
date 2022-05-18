#!/usr/bin/env python3

import pya

# filename is cmdline argument
gdsfile = filename
outname = filename.replace(".gds", "_flat.gds")
layout = pya.Layout()
prune = True
levels = -1

# Read each GDS files
layout.read(gdsfile)

# Perform flatting
topcell = layout.top_cell().name
topcell_index = (layout.cell(topcell).cell_index())
layout.flatten(topcell_index, levels, prune)
layout.write(outname)
