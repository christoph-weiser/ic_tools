import os 
import re
import pandas as pd
import numpy as np
import datatools as dt


def get_unique_tests(path):
    unique_tests = list()
    for elem in os.listdir(path):
        s = (elem.split("_"))[:-1]
        unique_tests.append("_".join(s))
    return unique_tests


def get_testresult(path, test, n=0, folder=False, numbered_only=True):
    results = list()
    for elem in os.listdir(path):
        if numbered_only: 
            if re.match(r"^{}_\d*$".format(test), elem):
                results.append(elem)
        else:
            if test in elem:
                results.append(elem)
    results = sorted(results, reverse=True)
    if folder: 
        return "{}{}{}".format(path, os.sep, results[n])
    else:
        return "{}{}{}{}summary.csv".format(path, os.sep, results[n], os.sep)


result_names = get_unique_tests("results")
results = os.getcwd() + os.sep + "results"

output_data = {}
for elem in result_names:

    latest = get_testresult(results, elem, n=0)
    df = pd.read_csv(latest)
    outputs = df.par.unique()

    columns = list(df.columns)
    filter_columns = ["netlist", "par", "val"]
    variables = [x for x in columns if x not in filter_columns]
        

    for out in outputs:
        output_data[out] = dict()
        dfv = df[df.par == out]
        output_data[out]["test"] = elem
        output_data[out]["min"]  = dt.eng(min(dfv.val))
        output_data[out]["max"]  = dt.eng(max(dfv.val))
        output_data[out]["mean"] = dt.eng(float(np.mean(dfv.val)))
        output_data[out]["std"]  = dt.eng(float(np.std(dfv.val)))


dfo = pd.DataFrame.from_dict(output_data, orient='index')

with open("results.md", "w") as ofile:
    for elem in result_names:
        ofile.write("# {}\n\n".format(elem))
        dfof = dfo[dfo.test == elem]
        dfof = dfof.drop("test", axis=1)
        ofile.write(dfof.to_markdown())
        ofile.write("\n\n\n")
