#!/bin/bash

# Update package list
sudo apt-get update

# Install git, python3-pip, vim, and python3-tk
sudo apt-get install -y git python3-pip vim python3-tk

# Check installed versions
echo "Installed software versions:"
echo "Git: $(git --version)"
echo "Python 3: $(python3 --version)"
echo "pip: $(pip3 --version)"
echo "Vim: $(vim --version | head -n 1)"
