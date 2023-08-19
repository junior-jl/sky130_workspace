#!/bin/bash
set -e

echo "Install Yosys"

# Install required dependencies
yes | sudo apt-get install build-essential clang bison flex \
	libreadline-dev gawk tcl-dev libffi-dev git \
	graphviz xdot pkg-config python3 libboost-system-dev \
	libboost-python-dev libboost-filesystem-dev zlib1g-dev

# Clone Yosys repository
git clone https://github.com/YosysHQ/yosys
cd yosys
make config-clang
make config-gcc
make
sudo make install
cd ..
