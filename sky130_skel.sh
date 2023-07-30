#!/bin/bash
SCRIPT_DIR=$(dirname "$0")
export SCRIPT_DIR
chmod u+x *.sh
./1-solve_dependencies.sh
./2-skywater_pdk.sh
./3-magic.sh
./4-xschem.sh
./5-ngspice_adms.sh
./6-klayout.sh
./7-netgen.sh
./8-asitic.sh
./9-gedit-spice-highlight.sh
./10-gaw.sh
./11-ghdl,gtkwave,iverilog,yosys.sh
./12-openlane.sh
