import argparse
import re
import spatk as sp

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--source",
                        type=str,
                        help="Netlist to process")
    args = parser.parse_args()
    filename = args.source
    res = []
    with open(filename, "r") as f:
        data = f.read()
        data = data.split("\n")
    for line in data:
        if re.match(r'^[A-Z]\$',line):
            line = "X" + line
            s = line.split(" ")
            s[0] = s[0].replace("$", "")
            line = " ".join(s)
            line = re.sub("\$\d*", "", line)
        res.append(line)
    netlist = "\n".join(res)
    cir = sp.Circuit(netlist, is_filename=False)
    cir.write("netlist-ext.sp")
