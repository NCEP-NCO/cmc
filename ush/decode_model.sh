#!/bin/bash

# ***********************************************************************
# decode_model
#
# This script decodes a GRIB message file into a GEMPAK grid file.
#
# decode_model  gbfile nagrib_table
#
# Input parameters:
# $1    gbfile        file name of GRIB message file
#
# Log:
# Programmer        Date       Change Description
# ----------        ----       ------------------
# DWPlummer/NCEP    11/20/00   New
# L.J.Cano          06/14/01   added optional table dir, initially done
#                                  for fnmoc wave model.
# P.O'Reilly        07/17/07   Modified to create GEMPAK file into
#                                  temp file, then move to final resting
#                                  place when complete
# K.Menlove         01/21/15   Ported to standard production environment
# ***********************************************************************

gbfile=$1
log=$DATA/$pgmout

if [ -n "$nagribtable" ]; then
    cp $nagribtable/* .
fi

cpyfil=gds
maxgrd=5000
output=T
garea=dset

echo "`date -u` -- Converting GRIB file $gbfile to GEMPAK file $gdoutf." >>$log

nagrib_nc << EOF >>$log
GBFILE=$gbfile
GDOUTF=$gdoutf
CPYFIL=$cpyfil
MAXGRD=$maxgrd
OUTPUT=$output
GAREA=$garea
l
r

ex
EOF

echo "`date -u` -- Conversion complete for GRIB file $gbfile to GEMPAK file $gdoutf" >>$log

exit 0
