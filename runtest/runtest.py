#!/usr/bin/env python3

import os
import argparse
import logging
import multiprocessing
import spctl

if __name__ == "__main__":

    logging.basicConfig(level=logging.INFO, format='[%(asctime)s] %(levelname)s - %(message)s')
    logger = logging.getLogger(__name__)

    parser = argparse.ArgumentParser()
    parser.add_argument("--source",
                        type=str,
                        help="config file with case setup")
    parser.add_argument("--cores",
                        type=str,
                        help="number of cores for multiprocess")
    parser.add_argument("--simulator",
                        type=str,
                        help="which simulator to use (ngspice,xyce)")
                        
    args = parser.parse_args()

    configfile = args.source

    cores = int(args.cores)
    if not cores:
        cores = 1

    simulator = args.simulator
    if not simulator:
        simulator = "ngspice"

    cases, paths = spctl.setup(configfile)
  
    paths["file_xschemrc"] = os.getenv("XSCHEMRC")
    paths["path_corners"]  = os.getenv("CORNERS")

  
    paths["file_netlist"] = spctl.create_netlist(paths["file_schematic"],
                                                 paths["path_netlists"],
                                                 paths["file_xschemrc"])
  
    with multiprocessing.Manager() as manager:
        result_queue = manager.Queue()
        writer = multiprocessing.Process(target=spctl.file_writer, 
                                         args=(result_queue, 
                                         paths["file_summary"]))
        writer.start()
        with multiprocessing.Pool(processes=cores) as pool:
            args_list = [(paths, c, result_queue, simulator) for c in cases]
            pool.starmap(spctl.run_cases, args_list)
        result_queue.put("exit")
        writer.join()
