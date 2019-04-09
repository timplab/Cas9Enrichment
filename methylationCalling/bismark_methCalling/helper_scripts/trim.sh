#!/bin/bash

#Ok - take in the root dir from command line arg 
##If command line arg empty - or not a dir - die                                      

if [ ! -d "$1" ]; then
    echo 
    echo "$1: No arg or dir doesn't exist"
    exit 1
else
    rawdir=$1
fi

##fastq pattern
if [ -z "$2" ]; then
    echo $2
    echo "No fastq pattern selected"
    exit 1
else 
    samp=$2
fi

outdir=$3

#make a temp dir to store the trimmed files
tempdir=$outdir/${samp}/trimmed
#echo 'here is where the trimmed files are goin2:'
#echo $tempdir
#rm -rf $tempdir

rawread1=`ls ${rawdir}/${samp}*R1*.fastq.gz`
rawread2=`ls ${rawdir}/${samp}*R2*.fastq.gz`

mkdir -p $tempdir

trim_galore -q 25 --paired ${rawread1} ${rawread2} \
    -o ${tempdir} &>${outdir}/${samp}/${samp}_trimlog

