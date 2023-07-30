#!/bin/bash
SCRIPT_DIR=$(dirname "$0")
export SCRIPT_DIR
chmod u+x *.sh


function show_spinner() {
    local delay=0.1
    local spinstr='|/-\'
    while true; do
        printf "\r[${spinstr:i++%${#spinstr}:1}] Executing $1..."
        sleep "$delay"
    done
}


function stop_spinner() {
    if [ -n "$spinner_pid" ]; then
        kill "$spinner_pid" &>/dev/null
        wait "$spinner_pid" &>/dev/null
    fi
    printf "\r%${COLUMNS}s\r" ""  
}


function execute_with_spinner() {
    local script_name="$1"
    show_spinner "$script_name" &
    spinner_pid=$!
    "./$script_name" > "/tmp/$script_name.log" 2>&1
    stop_spinner
    echo "[$script_name] Done."
    cd $SCRIPT_DIR
}


execute_with_spinner "1-solve_dependencies.sh"
execute_with_spinner "2-skywater_pdk.sh"
execute_with_spinner "3-magic.sh"
execute_with_spinner "4-xschem.sh"
execute_with_spinner "5-ngspice_adms.sh"
execute_with_spinner "6-klayout.sh"
execute_with_spinner "7-netgen.sh"
execute_with_spinner "8-asitic.sh"
execute_with_spinner "9-gedit-spice-highlight.sh"
execute_with_spinner "10-gaw.sh"
execute_with_spinner "11-ghdl,gtkwave,iverilog,yosys.sh"
execute_with_spinner "12-openlane.sh"

