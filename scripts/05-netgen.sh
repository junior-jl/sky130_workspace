#!/bin/bash
set -e

echo "Netgen"
git clone https://github.com/RTimothyEdwards/netgen
cd netgen/
yes | ./configure 
sudo make
sudo make install
cd ..
echo "End"

