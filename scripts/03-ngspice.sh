#!/bin/bash
set -e

# download and install Ngspice with adms
echo "Download and install Ngspice with adms"
git clone git://git.code.sf.net/p/ngspice/ngspice
cd ngspice/
git checkout pre-master

## adms
echo "ADMS"
git clone https://github.com/Qucs/ADMS
cd ADMS/
sh bootstrap.sh
yes | ./configure
yes | sudo make install
cd ..

# ngspice - adms support
echo "ngspice - ADMS support"
wget -O ngspice-adms-va.7z https://sourceforge.net/projects/ngspice/files/ng-spice-rework/39/ngspice-adms-va.7z/download
7za e ngspice-adms-va.7z  -aoa
yes | ./autogen.sh --adms
mkdir release
cd release
yes | ../configure --with-x --enable-xspice --disable-debug --enable-cider --with-readline=yes --enable-openmp
make -j4
sudo make install
cd ../..

