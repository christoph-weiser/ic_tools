#!/usr/bin/env python3

import pya

gdsfile = filename
outname = filename.replace(".gds", "_no-polygons.gds")

layout = pya.Layout()
layout.read(filename)

layers = [x for x in layout.layer_indexes()]

for cell in layout.each_cell():
    for layer in layers:
        for s in cell.each_shape(layer):
            if s.path:
                a = s.path.polygon()
                s.polygon = a

layout.write(outname)
