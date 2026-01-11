#!/usr/bin/env python3

import argparse
import logging
import multiprocessing
import os
import sys 
import shutil
import spctl

from spctl.helpers import create_netlist
from spctl.regression import setup, file_writer, run_cases


if __name__ == "__main__":

    logging.basicConfig(level=logging.INFO, format='[%(asctime)s] %(levelname)s - %(message)s')
    logger = logging.getLogger(__name__)

    xschemrc = os.getenv("XSCHEMRC")
    corners  = os.getenv("CORNERS")

    parser = argparse.ArgumentParser()
    parser.add_argument("--configfile",
                        type=str,
                        help="config file with case setup")
    parser.add_argument("--cores",
                        type=str,
                        help="number of cores for multiprocess")
    parser.add_argument("--simulator",
                        type=str,
                        help="which simulator to use (ngspice,xyce)")
    parser.add_argument("--netlist",
                        type=str,
                        help="netlist file (optional) ")
    parser.add_argument("--dryrun",
                        action="store_true",
                        help="Only output the cases that will be run")

    args = parser.parse_args()

    configfile  = args.configfile
    netlistfile = args.netlist
    simulator   = args.simulator
    cores       = args.cores
    dryrun      = args.dryrun


    if not cores:
        cores = 1
    else:
        cores = int(cores)
    if not simulator:
        simulator = "ngspice"

    cases, paths = setup(configfile)

    paths["file_configfile"] = configfile
    paths["file_xschemrc"]   = xschemrc
    paths["path_corners"]    = corners

    if not args.netlist:
        paths["file_netlist"] = create_netlist(paths["file_schematic"],
                                               paths["path_netlists"],
                                               paths["file_xschemrc"])
    else:
        src = args.netlist
        name = os.path.basename(src)
        dst = "{}/{}".format(paths["path_netlists"], name)
        shutil.copyfile(src,dst) 
        paths["file_netlist"] = dst

    logger.info("config:    {}".format(paths["file_configfile"]))
    logger.info("netlist:   {}".format(paths["file_netlist"]))
    logger.info("simulator: {}".format(simulator))
    logger.info("cores:     {}".format(cores))
    logger.info("--------------------")
    logger.info("Total Cases: {}".format(len(cases)))
    logger.info("--------------------")
    if dryrun:
        logger.info(cases[0][0])
        for c in cases:
            logger.info(c[2])
        sys.exit()

    with multiprocessing.Manager() as manager:
        result_queue = manager.Queue()
        writer = multiprocessing.Process(target=file_writer, 
                                         args=(result_queue, 
                                         paths["file_summary"]))
        writer.start()
        with multiprocessing.Pool(processes=cores) as pool:
            args_list = [(c, result_queue, paths,  simulator) for c in cases]
            pool.starmap(run_cases, args_list)
        result_queue.put("exit")
        writer.join()
