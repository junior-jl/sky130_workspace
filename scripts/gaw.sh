#!/bin/bash
set -e

git clone https://github.com/StefanSchippers/xschem-gaw
cd xschem-gaw/

###      DO !!!!
# gedit po/Makefile.in.in
# GETTEXT_MACRO_VERSION = 0.20

aclocal && automake --add-missing && autoconf
yes | ./configure
make
sudo make install
cd ..

