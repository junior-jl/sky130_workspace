#!/bin/bash

# download skywater pdk
echo "Download skywater pdk"
git clone https://github.com/google/skywater-pdk
cd skywater-pdk

# initialise pdk and update submodules
echo "Initialise pdk and update submodules"
yes | sudo git submodule update --init libraries/sky130_fd_pr/latest \
                                libraries/sky130_fd_sc_hd/latest \
                                libraries/sky130_fd_sc_hdll/latest \
                                libraries/sky130_fd_sc_hs/latest \
                                libraries/sky130_fd_sc_ms/latest \
                                libraries/sky130_fd_sc_ls/latest \
                                libraries/sky130_fd_sc_lp/latest \
                                libraries/sky130_fd_sc_hvl/latest
sudo make timing

