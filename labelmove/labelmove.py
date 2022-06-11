#!/usr/bin/env python3

import pya

layout = pya.Layout()
layout.read(filename)

layers_id = layout.layer_indexes()
layers_info = layout.layer_infos()

# only metal layers M1 to M5
pin_layers = [(68,16), (69,16), (70,16), (71,16), (72,16)]
lab_layers = [(68,5),  (69,5),  (70,5),  (71,5),  (72,5)]

for pl, ll in zip(pin_layers, lab_layers):
    sli = None; dli = None
    for i,l in zip(layers_id, layers_info):
        if l.layer == ll[0] and l.datatype == ll[1]:
            sli = i
        if l.layer == pl[0] and l.datatype == pl[1]:
            dli = i
    if (sli and dli):
        layout.move_layer(sli, dli)

layout.write(filename)
