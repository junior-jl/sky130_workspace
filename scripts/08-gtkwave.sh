#!/bin/bash
set -e

echo "Install GTKWave"

# Install required dependencies
yes | sudo apt install libbz2-dev

# Clone GTKWave repository
git clone https://github.com/gtkwave/gtkwave
cd gtkwave/gtkwave3-gtk3/
./autogen.sh
yes | ./configure --enable-gtk3
make
sudo make install
cd ../..
