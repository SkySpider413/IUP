#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2018.3.1_AR72614 (64-bit)
#
# Filename    : compile.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for compiling the simulation design source files
#
# Generated by Vivado on Sun Apr 21 22:03:16 CEST 2024
# SW Build 2489853 on Tue Mar 26 04:18:30 MDT 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: compile.sh
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
echo "xvhdl --incr --relax -prj sim9_vhdl.prj"
ExecStep xvhdl --incr --relax -prj sim9_vhdl.prj 2>&1 | tee -a compile.log
