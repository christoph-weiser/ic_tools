#!/usr/bin/env python3

import pya

# filename is cmdline argument
gdsfile = filename
layout = pya.Layout()
layout.read(gdsfile)

for cell in layout.each_cell():
    outname = "{}.gds".format(cell.name)
    cell.write("blocks/{}".format(outname))
