#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2018.3.1_AR72614 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Fri Apr 19 23:53:26 CEST 2024
# SW Build 2489853 on Tue Mar 26 04:18:30 MDT 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep xelab -wto 545df467f1734161b93283ce656e98c7 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot sim8_behav xil_defaultlib.sim8 -log elaborate.log