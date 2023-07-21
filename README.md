# Tools for integrated circuit design

This is a collection of small integrated circuit design scripts.

## Usage

Many of the tools are based on magic and klayout, so make sure they are
included in your path if you want to run them. 

Also export a environment variable called IC_TOOLS that points
to this repository.

For example if you're in the ic_tools repository: 

```
export IC_TOOLS="$(pwd)"
```

Additionally the tools can be added to the PATH variable
and therefore be used as commandline tools. 

create symlinks to all tools:
```
chmod +x ./make.sh
./make.sh
```

Then the tools can be added to the PATH variable:
```
export PATH=$PATH:$IC_TOOLS/bin
```

For more information about the application of each tool 
refer to the note at the top of each script.

## Tools

- assemble          - prepare gds and extract netlist for lvs.
- drc               - run drc check
- extract           - netlist extraction for lvs.
- flatten           - flatten hierachical gds file.
- gdsbuild          - merge gds files into top-cell.
- gdsexport         - export all individual cells into seperate files.
- labelextract      - extract labels and pins from gds.
- labelmove         - move content from label layers to pin layers.
- labelremove       - remove all labels from a gds.
- lvs               - run lvs check.
- merge             - merge two gds files.
- pex               - extract pex netlist from gds.
- prefix            - add prefix to each cell name in gds.
- sky130_pnp_mod    - change extracted pnp devices to fit models.
- topcell           - create a top-cell from hierachical gds.
- xor               - calculate the xor between two layouts



