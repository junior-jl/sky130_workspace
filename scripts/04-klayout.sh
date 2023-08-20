#!/bin/bash
echo "Install Klayout sky130 tech"
mkdir -p ~/.klayout/tech
cd ~/.klayout/tech
git clone --quiet https://github.com/mabrains/sky130_klayout_pdk.git sky130
pip install --user pandas
echo "END"

