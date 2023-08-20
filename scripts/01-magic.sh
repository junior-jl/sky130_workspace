#!/bin/bash
echo "Download and install magic"
# download magic
git clone https://github.com/RTimothyEdwards/magic.git
cd magic

# compile & install magic
yes | sudo ./configure
yes | sudo make
yes | sudo make install
cd ..

# download the open pdk
git clone https://github.com/RTimothyEdwards/open_pdks
cd open_pdks

# configure & install open pdks
yes | sudo ./configure --enable-sky130-pdk="$SCRIPT_DIR/skywater-pdk/libraries"
echo $SCRIPT_DIR
yes | sudo make
yes | sudo make install
cd ../..

# create a symbolic link to magic libraries
sudo ln -s "$SCRIPT_DIR/open_pdks/sky130/sky130A/libs.tech/magic/"* /usr/local/lib/magic/sys/

# export PDK_ROOT environment variable
export PDK_ROOT="$SCRIPT_DIR/open_pdks/sky130"

