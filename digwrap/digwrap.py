import argparse
import re


def format_vector(signals):
    fsignals = list()
    for sig in signals:
        if re.match(r".*\.\d$", sig):
            fsignals.append("{}_".format(sig.replace(".","_")))
        else:
            fsignals.append(sig)
    return fsignals

def format_digital(signals):
    dig_signals = list()
    for sig in signals:
        dig_signals.append("d_{}".format(sig))
    return dig_signals


if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument("--source",
                        type=str,
                        help="Netlist to process")
    args = parser.parse_args()

    filename = args.source
    with open(filename, "r") as ifile:
        data = ifile.read()

    data = data.split("\n")
    subcktdef = ""
    in_circuit = False
    circuit = []
    for line in data:
        if re.match("^.ends.*", line, re.IGNORECASE):
            circuit.append(".ends\n")
            in_circuit = False
        if in_circuit:
            circuit.append(line.lower())
        if re.match("^.subckt.*", line, re.IGNORECASE):
            subcktdef = line
            in_circuit = True


    parts = subcktdef.split(" ")
    name = parts[1]
    signals = parts[2:]

    in_signals = list()
    out_signals = list()
    for signal in signals:
        if re.match("^i_.*", signal):
            in_signals.append(signal.lower())
        elif re.match("^o_.*", signal):
            out_signals.append(signal.lower())

    in_signals  = sorted(in_signals, reverse=True)
    out_signals = sorted(out_signals, reverse=True)

    in_vec_signals  = format_vector(in_signals)
    out_vec_signals = format_vector(out_signals)

    in_dig_signals  = format_digital(in_signals)
    out_dig_signals = format_digital(out_signals)

    in_dig_vec_signals  = format_vector(in_dig_signals)
    out_dig_vec_signals = format_vector(out_dig_signals)


    s_subckt_wrapper = ".subckt {} {} {} vdd vss"
    s_dig_instance = "xuut {} {} vdd vss {}_dig"
    s_adc_brige = "aadc [{}] [{}] adc_buf"
    s_dac_brige = "adac [{}] [{}] dac_buf"
    s_subckt_digital = ".subckt {} {} {} vdd vss"

    model_adc = ".model adc_buf adc_bridge(in_low = 0.2 in_high=0.8)"
    model_dac = ".model dac_buf dac_bridge(out_high = 1.8)"

    subckt_wrapper = s_subckt_wrapper.format(name,
                                             " ".join(in_vec_signals), 
                                             " ".join(out_vec_signals))

    dig_instance = s_dig_instance.format(" ".join(in_dig_vec_signals), 
                                         " ".join(out_dig_vec_signals),
                                         name)

    adc_brige = s_adc_brige.format(" ".join(in_vec_signals), 
                                   " ".join(in_dig_vec_signals))

    dac_brige = s_dac_brige.format(" ".join(out_dig_vec_signals), 
                                   " ".join(out_vec_signals))

    subckt_digital = s_subckt_digital.format("{}_dig".format(name),
                                              " ".join(in_signals),
                                              " ".join(out_signals))

    

    output = ["* Digital Module ",
              subckt_wrapper, 
              "",
              dig_instance,
              adc_brige,
              dac_brige,
              "",
              model_adc,
              model_dac,
              "",
              subckt_digital,
              ""]

    s_output = "\n".join(output) + "\n".join(circuit) + "\n.ends"

    with open("module.sp", "w") as ofile:
        ofile.write(s_output)
