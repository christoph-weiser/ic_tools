#!/usr/bin/env python3

import pya


# sky130
pin_layers = [(122,16), (64,16), (67,16), (68,16), (69,16), (70,16), (71,16), (72,16)]
lab_layers = [(64,59), (64,5), (67,5), (68,5), (69,5), (70,5), (71,5), (72,5)]

# gf180
# pin_layers = []
# lab_layers = [(21,10), (22,10), (204,10), (30,10), (34,10), (36,10), (42,10), (46,10), (81,10), (53,10)]

# filename is cmdline argument
gdsfile = filename
outname = filename.replace(".gds", "_nolab.gds")
layout = pya.Layout()
prune = True
levels = -1

# Read each GDS files
layout.read(gdsfile)

# Get layer information
layers_id = layout.layer_indexes()
layers_info = layout.layer_infos()


layers = {}; del_layers = []
for i,l in zip(layers_id, layers_info):
    layers[i] = (l.layer, l.datatype)
    for pl in pin_layers:
        if l.layer == pl[0] and l.datatype == pl[1]:
            del_layers.append(i)
    for ll in lab_layers:
        if l.layer == ll[0] and l.datatype == ll[1]:
            del_layers.append(i)


for dl in del_layers:
    layout.clear_layer(dl)

layout.write(outname)
