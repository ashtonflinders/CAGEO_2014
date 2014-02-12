#!/bin/bash

# A. Flinders
# ashton.f.flinders@gmail.com
# 
# February 13th, 2014
#
# This is script makes the proper directory structure for running the included Generic 
# Mapping Tools (GMT) x2sys crossover analysis example (x2sys_example.bash)
#
# Before using, make sure that you have downloaded all required example lines from the
# Github repository, as well as the example script.
#
# Example lines;
#	Healy_HLY0602_1_NADIR.xyzt
#	Healy_HLY0602_2_NADIR.xyzt
#	Healy_HLY0602_3_NADIR.xyzt
#	Healy_HLY0602_4_NADIR.xyzt
#	Healy_HLY0602_5_NADIR.xyzt
#	Healy_HLY0602_6_NADIR.xyzt
#
# Example script;
#	x2sys_example.bash
#
# All the above should be in the same directory, along with this script e.g.;
#
# ]$ls
#
# Healy_HLY0602_1_NADIR.xyzt
# Healy_HLY0602_2_NADIR.xyzt
# Healy_HLY0602_3_NADIR.xyzt
# Healy_HLY0602_4_NADIR.xyzt
# Healy_HLY0602_5_NADIR.xyzt
# x2sys_example.bash
# x2sys_makedir.bash
#
# Run this script from that local directory
#
# ]$./x2sys_makedir.bash
#
# The script will produce the following directory structure;
#
# ]$tree
#
# .
# ├── X2SYS_EXAMPLE
# │   ├── Healy_HLY0602
# │   │   └── XYZT
# │   │       ├── Healy_HLY0602_1_NADIR.xyzt
# │   │       ├── Healy_HLY0602_2_NADIR.xyzt
# │   │       ├── Healy_HLY0602_3_NADIR.xyzt
# │   │       ├── Healy_HLY0602_4_NADIR.xyzt
# │   │       └── Healy_HLY0602_5_NADIR.xyzt
# │   └── x2sys_example.bash
# └── x2sys_makedir.bash
#
# 3 directories, 7 files


mkdir ./X2SYS_EXAMPLE
mkdir ./X2SYS_EXAMPLE/Healy_HLY0602
mkdir ./X2SYS_EXAMPLE/Healy_HLY0602/XYZT

mv x2sys_example.bash ./X2SYS_EXAMPLE
mv Healy_HLY0602_*_NADIR.xyzt ./X2SYS_EXAMPLE/Healy_HLY0602/XYZT
