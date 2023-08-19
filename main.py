import os
import signal
import sys
import time

import PySimpleGUI as sg
import subprocess

# Define the program options with descriptions and associated scripts
program_options = [
    ('Asitic',
     'Asitic is a CAD tool that aids the RF circuit designer in optimizing and modeling spiral inductors, transformers, capacitors, and substrate coupling.',
     '06-asitic.sh'),
    ('GHDL', 'GHDL is an open-source VHDL simulator.', '07-ghdl.sh'),
    ('GTKWave', 'GTKWave is a waveform viewer for digital simulation results.', '08-gtkwave.sh'),
    ('IVerilog', 'IVerilog is an open-source Verilog simulator.', '10-iverilog.sh'),
    ('KLayout', 'KLayout is a layout viewer and editor for integrated circuit design.', '04-klayout.sh'),
    ('Magic VLSI', 'Magic VLSI is a layout editor and design tool for integrated circuits.', '01-magic.sh'),
    ('NGSpice', 'NGSpice is an open-source mixed-level/mixed-signal electronic circuit simulator.', '03-ngspice.sh'),
    ('Netgen', 'Netgen is a digital netlist comparison tool.', '05-netgen.sh'),
    ('OpenLane',
     'OpenLane is an open-source digital ASIC flow including EDA tools and PDKs for Skywater 130nm and other technologies.',
     '11-openlane.sh')
]

# Define a dictionary to map options to scripts
options_to_scripts = {option[0]: option[2] for option in program_options if option[2] is not None}

# Scripts that will always be installed
always_install_scripts = ['solve_dependencies.sh', 'skywater_pdk.sh', 'gedit-spice-highlight.sh', 'gaw.sh']

# Define the installation directory section
install_directory_section = [
    [sg.Text('Please select the installation directory:')],
    [sg.InputText(key='-FOLDER-'), sg.FolderBrowse()],
]

# Sort the program_options alphabetically
program_options = sorted(program_options, key=lambda x: x[0].lower())

# Define the program selection section as a column
program_selection_section = [
    [
        sg.Column(
            [
                [sg.Checkbox(option[0], key='-' + option[0] + '-', default=False, tooltip=option[1])]
                for option in program_options
            ],
            vertical_alignment='top'
            # size=(400, 400)
        )
    ],
]

# Define the buttons section
buttons_section = [
    [sg.Button('Install'), sg.Button('Cancel')],
]


def run_gui():
    # Combine layout sections
    layout = [
        [sg.Image(filename='images/sky130google.png', size=(600, 168))],
        [sg.Text('Skywater 130nm Toolchain Installer', font=('Helvetica', 18))],
        install_directory_section,
        [sg.Text('Select programs to install:')],
        [sg.Button('Select All')],
        program_selection_section,  # Use the program_selection_section here
        buttons_section,
    ]

    # Create the window
    window = sg.Window('Skywater 130nm Toolchain Installer', layout, resizable=True, finalize=True)

    # Event loop
    while True:
        event, values = window.read()
        if event == sg.WINDOW_CLOSED or event == 'Cancel':
            break
        elif event == 'Select All':
            for option in program_options:
                window['-' + option[0] + '-'].update(True)
        elif event == 'Install':
            install_directory = values['-FOLDER-']

            # Check if the installation directory is empty
            if not install_directory:
                sg.popup('Please select an installation directory.', title='Error')
                continue

            os.environ["SCRIPT_DIR"] = install_directory

            print(f"SCRIPT_DIR is set to: {os.environ.get('SCRIPT_DIR')}")

            # Check which programs the user selected to install
            selected_options = [option for option in program_options if values['-' + option[0] + '-']]

            # Initialize a flag to check if the mandatory scripts are added
            mandatory_scripts_added = False

            # Add the scripts that will always be installed
            selected_scripts = []

            # Check if there are no optional programs selected (excluding always-install scripts)
            if not selected_options:
                confirm_popup = sg.popup_yes_no(
                    'No optional programs selected. Install only the Skywater PDK?',
                    title='Confirmation'
                )
                if confirm_popup == 'Yes':
                    selected_scripts.append('solve_dependencies.sh')
                    selected_scripts.append('skywater_pdk.sh')  # Only install Skywater PDK
                    mandatory_scripts_added = True
                else:
                    continue  # User canceled

            # If mandatory scripts are not added, add them
            if not mandatory_scripts_added:
                selected_scripts.extend(always_install_scripts)

            # Append the selected scripts
            selected_scripts.extend([options_to_scripts[option[0]] for option in selected_options])

            # Request sudo password
            sudo_password = sg.popup_get_text('Please enter your sudo password:', password_char='*')
            if not sudo_password:
                continue

            # Run the selected scripts
            for script in selected_scripts:
                script_path = f'scripts/{script}'
                try:
                    subprocess.run(['bash', script_path, sudo_password], check=True)
                    sg.popup('Script executed successfully!', title='Success')
                except subprocess.CalledProcessError as e:
                    sg.popup_error(f'An error occurred while executing the script: {e}', title='Error')

                # print(f"Running {script_path}")

            # Add your installation logic here if needed
            install_message = f'Installing the following scripts to \n{install_directory}:\n'
            install_message += '\n'.join(selected_scripts)
            sg.popup(install_message, title='Installation Progress')

    # Close the window
    window.close()


def run_cli(install_directory):
    import os
    import subprocess
    import sys

    # Set the SCRIPT_DIR environment variable to the installation directory
    os.environ["SCRIPT_DIR"] = install_directory

    print(f"SCRIPT_DIR is set to: {os.environ.get('SCRIPT_DIR')}")

    def show_spinner(message):
        spinstr = "|/-\\"
        delay = 0.1
        i = 0
        while True:
            sys.stdout.write(f"\r[{spinstr[i]}] Executing {message}...")
            sys.stdout.flush()
            i = (i + 1) % len(spinstr)
            time.sleep(delay)

    def stop_spinner(spinner_pid):
        if spinner_pid:
            os.kill(spinner_pid, signal.SIGTERM)
            os.waitpid(spinner_pid, 0)
        sys.stdout.write("\r" + " " * os.get_terminal_size().columns + "\r")
        sys.stdout.flush()

    def execute_with_spinner(script_name):
        show_spinner(script_name)
        spinner_pid = None
        try:
            spinner_pid = os.fork()
            if spinner_pid == 0:
                # Print the value of SCRIPT_DIR before executing the script
                print(f"SCRIPT_DIR is set to: {os.environ.get('SCRIPT_DIR')}")

                with open(f"/tmp/{script_name}.log", "w") as log_file:
                    subprocess.run(["./" + script_name], stdout=log_file, stderr=subprocess.STDOUT)
                os._exit(0)
            else:
                _, status = os.waitpid(spinner_pid, 0)
                return status
        finally:
            stop_spinner(spinner_pid)

    # Programs to install
    programs_to_install = []

    # Program names mapping
    program_names = [
        "Magic",
        "XSchem",
        "NGSpice",
        "KLayout",
        "Netgen",
        "Asitic",
        "GHDL",
        "GTKWave",
        "Yosys",
        "IVerilog",
        "OpenLane",
    ]

    # Parse command line arguments
    args = sys.argv[2:]
    while args:
        arg = args.pop(0)
        if arg in ["-a", "--all"]:
            programs_to_install.extend([f"{i + 1:02d}-{name.lower()}.sh" for i, name in enumerate(program_names)])
        elif arg in ["-p", "--programs"]:
            while args:
                arg = args.pop(0)
                try:
                    program_number = int(arg)
                    if 1 <= program_number <= len(program_names):
                        programs_to_install.append(
                            f"{program_number:02d}-{program_names[program_number - 1].lower()}.sh")
                    else:
                        print(f"Invalid program number: {arg}")
                        sys.exit(1)
                except ValueError:
                    print(f"Invalid program number: {arg}")
                    sys.exit(1)
        elif arg.startswith("--"):
            program_name = arg.lstrip("-")
            lowercase_names = [name.lower() for name in program_names]
            if program_name.lower() in lowercase_names:
                program_index = lowercase_names.index(program_name.lower())
                program_number = program_index + 1
                programs_to_install.append(f"{program_number:02d}-{program_name.lower()}.sh")
            else:
                print(f"Invalid program name: {arg}")
                sys.exit(1)
        else:
            print(f"Invalid option: {arg}")
            sys.exit(1)

    # Ensure the scripts are sorted and unique
    programs_to_install = sorted(set(programs_to_install))

    # Check if there are no program installation arguments
    if not programs_to_install:
        confirm_install_pdk = input(
            "No program installation arguments detected. Do you want to install only the Skywater PDK? (yes/no): ")
        if confirm_install_pdk.strip().lower() in ['yes', 'y', 'Y']:
            programs_to_install = ["solve_dependencies.sh", "skywater_pdk.sh"]
            for script in programs_to_install:
                execute_with_spinner(script)
                # print(f"Simulating execution of {script}")
        else:
            print("No programs selected. Exiting.")
            sys.exit(0)
    else:
        # Run mandatory scripts
        mandatory_scripts = ["solve_dependencies.sh", "skywater_pdk.sh", "gedit-spice-highlight.sh", "gaw.sh"]
        for script in mandatory_scripts:
            execute_with_spinner(script)
            # print(f"Simulating execution of {script}")

        # Run selected scripts
        for script in programs_to_install:
            execute_with_spinner(script)
            # print(f"Simulating execution of {script}")


def main():
    # Check for the help flag
    if '-h' in sys.argv or '--help' in sys.argv:
        print("Usage: python3 main.py [options]")
        print("Options:")
        print("  -gui,           Open the graphical interface")
        print("  -h, --help      Show this help message and exit")
        print("  -a, --all       Install all available programs")
        print("  -p, --programs  Install specific programs by number")
        print("  Example: -p 1 3 7 will install Magic, NGSpice, and GHDL")
        print("  --magic          Install Magic")
        print("  --xschem         Install XSchem")
        print("  --ngspice        Install NGSpice")
        print("  --klayout        Install KLayout")
        print("  --netgen         Install Netgen")
        print("  --asitic         Install Asitic")
        print("  --ghdl           Install GHDL")
        print("  --gtkwave        Install GTKWave")
        print("  --yosys          Install Yosys")
        print("  --iverilog       Install IVerilog")
        print("  --openlane       Install OpenLane")
        sys.exit(0)

    # Check if the first argument is provided as the installation directory, -gui, or -h
    install_directory = None
    if len(sys.argv) > 1:
        arg = sys.argv[1]
        if arg == '-gui':
            run_gui()
            return
        elif arg != '-h' and not arg.startswith('-'):
            install_directory = arg

    if install_directory is None:
        print("Usage: python3 main.py <install_directory> [-gui] [-h]")
        sys.exit(1)

    run_cli(install_directory)


if __name__ == '__main__':
    main()
