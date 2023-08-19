#!/bin/bash
set -e

echo "Download and install Xschem"
git clone https://github.com/StefanSchippers/xschem
cd xschem/
./configure
make 
sudo make install
cd ..
mkdir -p ~/.xschem/simulations

# libs sky130 to xschem
echo "libs sky130 to xschem"
cd ~/.xschem/simulations/
cp "$SCRIPT_DIR/utilities/.spiceinit" .spiceinit
cd ..
mkdir -p xschem_library
cd xschem_library/
git clone https://github.com/StefanSchippers/xschem_sky130
cd "$SCRIPT_DIR"
ln -s ~/.xschem/xschem_library/xschem_sky130
ln -s "$SCRIPT_DIR/skywater-pdk/libraries/sky130_fd_pr" /usr/local/share/pdk/sky130A/libs.ref

# config pdk to xschem and ngspice
echo "Config pdk to xschem and ngspice"
# Uncomment the following lines if needed
#cp -a "$SCRIPT_DIR/skywater-pdk/libraries/sky130_fd_pr" "$SCRIPT_DIR/skywater-pdk/libraries/sky130_fd_pr_ngspice"
#cd "$SCRIPT_DIR/skywater-pdk/libraries/sky130_fd_pr_ngspice/latest/"
#patch -p2 < ~/.xschem/xschem_library/xschem_sky130/sky130_fd_pr.patch
#cd ../../../../

