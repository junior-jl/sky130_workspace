#!/bin/bash
set -e

echo "Install GHDL"
# Install GNAT
yes | sudo apt install gnat

# Clone GHDL repository
git clone https://github.com/ghdl/ghdl
cd ghdl/
./configure --enable-synth
make
sudo make install
cd ..
