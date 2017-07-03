#!/bin/sh

export ori_dir=$(pwd)
cd ${MATLAB_HOME}/bin
./matlab -nodisplay -r 'cd ${ori_dir}; server'
