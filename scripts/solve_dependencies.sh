#!/bin/bash

# Solve dependencies
echo "Solve dependencies"
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -y && \
sudo apt-get upgrade -y && \
sudo apt-get install \
    gcc autoconf automake patch patchutils indent libtool python3 cmake git \
    make libx11-6 libx11-dev libxrender1 libxrender-dev libxcb1 libx11-xcb-dev \
    libcairo2 libcairo2-dev tcl8.6 tcl8.6-dev tk8.6 tk8.6-dev flex bison libxpm4 \
    libxpm-dev gawk m4 \
    m4 tcsh csh libx11-dev tcl-dev tk-dev libcairo2-dev libncurses-dev \
    libglu1-mesa-dev freeglut3-dev mesa-common-dev \
    build-essential \
    automake libtool gperf flex bison \
    libxml2 libxml2-dev \
    libxml-libxml-perl \
    libgd-perl \
    p7zip \
    adms \
    libxaw7-dev \
    libreadline-dev libreadline8 \
    p7zip-full \
    xterm \
    gtk2.0 \
    python3-pip klayout \
    libgtk-3-dev \
    libasound2 \
    alsa -y

# Uncomment if you want to install KLayout
#sudo apt-get install qt5-default -y
#sudo add-apt-repository ppa:deadsnakes/ppa
#sudo apt-get update
#sudo apt-get install python3.8 -y
#sudo apt-get install python3.8-dev -y
#sudo apt-get install libqt5xmlpatterns5-dev -y
#sudo apt-get install qttools5-dev -y
#sudo apt-get install qtmultimedia5-dev libqt5multimediawidgets5 -y
#sudo apt-get install libqt5svg5* -y
#sudo apt-get install libqt5svg5-dev -y
#sudo apt-get install gedit -y

