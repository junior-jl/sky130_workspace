#!/bin/bash

# download and install Ngspice with adms
echo "Download and install Ngspice with adms"
git clone git://git.code.sf.net/p/ngspice/ngspice
cd ngspice/
./autogen.sh --adms
mkdir release
cd release
../configure --with-x --enable-xspice --disable-debug --enable-cider --with-readline=yes --enable-openmp
sudo make
sudo make install