#!/bin/bash
set -e

# ASITIC
echo "Install ASITIC"
# Asitic
sudo apt-get install gcc-multilib -y

mkdir -p asitic
cd asitic
wget http://rfic.eecs.berkeley.edu/~niknejad/Asitic/grackle/asitic_linux.gz
wget http://rfic.eecs.berkeley.edu/~niknejad/Asitic/grackle/doc_05_28_01.tgz
wget http://rfic.eecs.berkeley.edu/~niknejad/Asitic/3.19.00/common.tgz

gzip -d asitic_linux.gz
tar -xvzf doc_05_28_01.tgz 
tar -xvzf common.tgz 

chmod +x asitic_linux

sudo dpkg --add-architecture i386
yes | sudo apt-get update
yes | sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 -y
yes | sudo apt-get install libxtst6:i386 -y

wget http://old-releases.ubuntu.com/ubuntu/pool/universe/g/gcc-3.4/libg2c0_3.4.6-6ubuntu5_i386.deb
wget https://launchpad.net/ubuntu/+source/gcc-3.4/3.4.6-6ubuntu5/+build/601913/+files/gcc-3.4-base_3.4.6-6ubuntu5_i386.deb
yes | sudo dpkg -i --force-all libg2c0_3.4.6-6ubuntu5_i386.deb
yes | sudo dpkg -i --force-all gcc-3.4-base_3.4.6-6ubuntu5_i386.deb

echo "Downloading ASITIC .tek file from yrrapt@github repository..."
wget https://raw.githubusercontent.com/yrrapt/inductor-generator/main/asitic/sky130.tek

echo "asitic_sky130"
cp "$SCRIPT_DIR/utilities/asitic_sky130" asitic_sky130
chmod +x asitic_sky130

cd ..

