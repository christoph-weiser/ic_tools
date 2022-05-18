#!/usr/bin/env python3

import pya

# filename is cmdline argument
gdsfile_a = filename_a
gdsfile_b = filename_b
outname = "merged.gds"

layout = pya.Layout()

# Read each GDS files
layout.read(gdsfile_a)
layout.read(gdsfile_b)

# print(layout)
layout.write(outname)
