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
    cd "$SCRIPT_DIR"
}

# Programs to install
programs_to_install=()

# Program names mapping
program_names=(
    "Magic"
    "XSchem"
    "NGSpice"
    "KLayout"
    "Netgen"
    "Asitic"
    "GHDL"
    "GTKWave"
    "Yosys"
    "IVerilog"
    "OpenLane"
)

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            echo "Usage: ./sky130_skel.sh [options]"
            echo "Options:"
            echo "  -h, --help      Show this help message and exit"
            echo "  -a, --all       Install all available programs"
            echo "  -p, --programs  Install specific programs by number"
            echo "    1 - Magic"
            echo "    2 - XSchem"
            echo "    3 - NGSpice"
            echo "    4 - KLayout"
            echo "    5 - Netgen"
            echo "    6 - Asitic"
            echo "    7 - GHDL"
            echo "    8 - GTKWave"
            echo "    9 - Yosys"
            echo "    10 - IVerilog"
            echo "    11 - OpenLane"
            echo "  Example: -p 1 3 7 will install Magic, NGSpice and GHDL"
            echo "  --magic          Install Magic"
            echo "  --xschem         Install XSchem"
            echo "  --ngspice        Install NGSpice"
            echo "  --klayout        Install KLayout"
            echo "  --netgen         Install Netgen"
            echo "  --asitic         Install Asitic"
            echo "  --ghdl           Install GHDL"
            echo "  --gtkwave        Install GTKWave"
            echo "  --yosys          Install Yosys"
            echo "  --iverilog       Install IVerilog"
            echo "  --openlane       Install OpenLane"
            exit 0
            ;;
        -a|--all)
            programs_to_install+=("01-magic.sh" "02-xschem.sh" "03-ngspice.sh" "04-klayout.sh" "05-netgen.sh" "06-asitic.sh" "07-ghdl.sh" "08-gtkwave.sh" "09-yosys.sh" "10-iverilog.sh" "11-openlane.sh")
            shift
            ;;
        -p|--programs)
            shift
            for arg in "$@"; do
                case "$arg" in
                    [1-9]|10|11)
                        programs_to_install+=("$(printf "%02d" "$arg")-${program_names[arg-1],,}.sh")
                        ;;
                    *)
                        echo "Invalid program number: $arg"
                        exit 1
                        ;;
                esac
            done
            break
            ;;
        --*)
            # Handle individual program flags with double dash
            case "$1" in
                --magic)
                    programs_to_install+=("01-magic.sh")
                    ;;
                --xschem)
                    programs_to_install+=("02-xschem.sh")
                    ;;
                --ngspice)
                    programs_to_install+=("03-ngspice.sh")
                    ;;
                --klayout)
                    programs_to_install+=("04-klayout.sh")
                    ;;
                --netgen)
                    programs_to_install+=("05-netgen.sh")
                    ;;
                --asitic)
                    programs_to_install+=("06-asitic.sh")
                    ;;
                --ghdl)
                    programs_to_install+=("07-ghdl.sh")
                    ;;
                --gtkwave)
                    programs_to_install+=("08-gtkwave.sh")
                    ;;
                --yosys)
                    programs_to_install+=("09-yosys.sh")
                    ;;
                --iverilog)
                    programs_to_install+=("10-iverilog.sh")
                    ;;
                --openlane)
                    programs_to_install+=("11-openlane.sh")
                    ;;
                *)
                    echo "Invalid program flag: $1"
                    exit 1
                    ;;
            esac
            shift
            ;;
        -*)
            echo "Invalid option: $1"
            exit 1
            ;;
        *)
            echo "Invalid argument: $1"
            exit 1
            ;;
    esac
done

# Ensure the scripts are sorted and unique
programs_to_install=($(echo "${programs_to_install[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

mandatory_scripts=("solve_dependencies.sh", "skywater_pdk.sh", "gedit-spice-highlight.sh", "gaw.sh")

# Run mandatory scripts
for script in "${mandatory_scripts[@]}"; do
    #execute_with_spinner "$script"
    echo "Simulating execution of $script"
done

# Run selected scripts
for script in "${programs_to_install[@]}"; do
    #execute_with_spinner "$script"
    echo "Simulating execution of $script"
done
