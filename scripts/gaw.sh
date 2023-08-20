#!/bin/bash

git clone https://github.com/StefanSchippers/xschem-gaw
cd xschem-gaw/

# Automatically replace the line in Makefile.in.in
sed -i 's/GETTEXT_MACRO_VERSION = 0.18/GETTEXT_MACRO_VERSION = 0.20/' po/Makefile.in.in

aclocal && automake --add-missing && autoconf
yes | ./configure
make
sudo make install
cd ..
