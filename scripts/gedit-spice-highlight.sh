#!/bin/bash

echo "Install Gedit Spice Highlight"
git clone https://github.com/thomasysliu/Gedit-SPICE-syntax-highlighting
cd Gedit-SPICE-syntax-highlighting/
mkdir -p ~/.local/share/gtksourceview-4/language-specs/
cp spice.lang ~/.local/share/gtksourceview-4/language-specs/
cd ..

