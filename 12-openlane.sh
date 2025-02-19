#!/bin/bash
set -e

# Openlane
sudo apt install python3.10-venv curl tcllib -y
cd openlane

yes | sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
yes | sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
yes | sudo apt install docker-ce

sudo usermod -aG docker $USER
sudo chmod 666 /var/run/docker.sock

make
export PDK_ROOT="$SCRIPT_DIR/open_pdks/sky130/"
sudo rm -rf "$SCRIPT_DIR/open_pdks/sky130/sky130A"
sudo rm -rf "$SCRIPT_DIR/open_pdks/sky130/sky130B"
make pdk
make test
cd ..

