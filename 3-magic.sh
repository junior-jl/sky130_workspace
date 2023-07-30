#!/bin/bash
echo "Download and install magic"
# download
git clone https://github.com/RTimothyEdwards/magic.git
cd magic
#git checkout magic-8.3
# compile & install
sudo ./configure
sudo make
sudo make install
cd ..
#download the open pdk
git clone https://github.com/RTimothyEdwards/open_pdks
cd open_pdks
#git checkout open_pdks-1.0
sudo ./configure --enable-sky130-pdk=$SCRIPT_DIR/skywater-pdk/libraries
sudo make
sudo make install
cd ../..
sudo ln -s $SCRIPT_DIR/open_pdks/sky130/sky130A/libs.tech/magic/* /usr/local/lib/magic/sys/
export PDK_ROOT=$SCRIPT_DIR/open_pdks/sky130
