#!/bin/sh

cd ${MATLAB_HOME}/bin
./matlab -nodisplay -r 'cd ~/ShopPositioningServer; server'
