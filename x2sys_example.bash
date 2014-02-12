#!/bin/bash

# A. Flinders
# ashton.f.flinders@gmail.com
# 
# February 13th, 2014
#
# This is an example script for running Generic Mapping Tools (GMT) x2sys crossover
# analysis on extracted multibeam nadir lines. This script can be used as it for a single
# cruise, or batched to run through multiple.
#
# This script is not necessarily specific to multibeam nadir lines, but can be used as a
# general example of how to use the x2sys package.
# 
# Before using, make sure that you have downloaded all required example lines from the
# Github repository, as well as run the script to set up the proper directory structure (or
# created it yourself).
#
# Example lines;
#	Healy_HLY0602_1_NADIR.xyzt
#	Healy_HLY0602_2_NADIR.xyzt
#	Healy_HLY0602_3_NADIR.xyzt
#	Healy_HLY0602_4_NADIR.xyzt
#	Healy_HLY0602_5_NADIR.xyzt
#	Healy_HLY0602_6_NADIR.xyzt
#
# Make directory structure (run prior to this script!)
#	x2sys_makedir.bash
#
# Then change into the X2SYS_EXAMPLE directory, and run this script;
#
# X2SYS_EXAMPLE ]$./x2sys_example.bash

# On some machines its necessary to change the maximum stack size for large data sets
ulimit -s 12288

# Cruise identifier
fileID="Healy_HLY0602"

ROOT_DIR=`pwd`
CRUISE_DIR=$ROOT_DIR"/"$fileID
X2SYS_DIR=$CRUISE_DIR"/X2SYS"
NADIR_DIR=$CRUISE_DIR"/XYZT"

# remove existing x2sys system directories\files for example cruise, make a blank ones
if [ -d "$X2SYS_DIR" ]; then
	rm -rf $X2SYS_DIR
fi
mkdir $X2SYS_DIR

# Create xyzt definition file
cat > $X2SYS_DIR"/xyzt.def" << EOF
# Define file for X2SYS processing of ASCII xyz files
# This file applies to a 4-column ASCII files, generated from dumping the nadir beam;
# longitude, latitude, depth, unix time
# from mbsbystem using the command;
# mblist -I $input file list -OXYZU -P3 > $output file
#---------------------------------------------------------------------
#ASCII		# The input file is ASCII
#SKIP 1		# The number of header records to skip
#---------------------------------------------------------------------
#name	intype	NaN-proxy?	NaN-proxy	scale	offset	oformat
x		a	N		0		1	0	%g
y		a	N		0		1	0	%g
z		a	N		0		1	0	%g
time	a	N		0		1	0	%g
EOF

# Save the default x2sys home location (if set)
X2SYS_HOME_OLD=$X2SYS_HOME

# Change the default x2sys home directory to the local directory for our example
cd $X2SYS_DIR
export X2SYS_HOME=`pwd`

# Initialize the TAG folder
x2sys_init $fileID -Gd -Cg -Dxyzt -F -V -Wd1
cd $fileID

# Copy cruise trackline filenames to datalist.d
ls $NADIR_DIR > datalist.d

# Create path file
# the absolute path to the folder with the extracted nadir beams
echo $NADIR_DIR > $fileID"_paths.txt"

# Calculate crossovers
# Set speed constraint so that we dont calculate crossings for speeds less that 1.0289 m/s
# e.g.  2 knots......(helps remove self crossings from holding position)
x2sys_cross --TIME_SYSTEM=UNIX =datalist.d -T$fileID -2 -Qe -V -Sl1.0289 > $fileID.CROSS

if test -s $fileID.CROSS; then 
	echo "CROSSOVERS FOUND"; 

	# Output the crossovers from the database
	x2sys_list -Cz -T$fileID $fileID.CROSS -FNc -V > tmp

	# x2sys_list has a tendency to find "self crossings" along straight line segments (yes,
	# even with the speed constraint). We will remove these from the list. It is thereby
	# important to make sure your lines are not obscenely long and self-crossing.
	awk '{if ($1 != $2) {print $0} else next}' tmp > $fileID.LIST
	/bin/rm tmp
	
	# Find corrections (although we dont apply any)
	x2sys_solve -Cz -T$fileID $fileID.LIST -V -Ec > $fileID.SOLVE

	touch N_`awk 'NR > 3 {print $0}' *.LIST | minmax | awk '{print $4}'`

else 
	echo "NO CROSSOVERS.....ABORTING...."
fi
