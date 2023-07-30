#!/bin/bash
set -e

# GHDL
yes | sudo apt install gnat

git clone https://github.com/ghdl/ghdl
cd ghdl/
./configure --enable-synth
make
sudo make install
cd ..

# GTKWave
yes | sudo apt install libbz2-dev

git clone https://github.com/gtkwave/gtkwave
cd gtkwave/gtkwave3-gtk3/
./autogen.sh
yes | ./configure --enable-gtk3
make
sudo make install
cd ../..

# Yosys
yes | sudo apt-get install build-essential clang bison flex \
	libreadline-dev gawk tcl-dev libffi-dev git \
	graphviz xdot pkg-config python3 libboost-system-dev \
	libboost-python-dev libboost-filesystem-dev zlib1g-dev

git clone https://github.com/YosysHQ/yosys
cd yosys
make config-clang
make config-gcc
make 
sudo make install
cd ..

# Icarus Verilog
yes | sudo apt-get install verilog

# GHDL Yosys plugin
git clone https://github.com/ghdl/ghdl-yosys-plugin
cd ghdl-yosys-plugin/
make
cd ..

# if has problems with ghdl.so
sudo rm /usr/local/share/yosys/plugins/ghdl.so
sudo mkdir -p /usr/local/share/yosys/plugins/
sudo cp ghdl-yosys-plugin/ghdl.so /usr/local/share/yosys/plugins/
sudo chmod 777 /usr/local/share/yosys/plugins/ghdl.so

