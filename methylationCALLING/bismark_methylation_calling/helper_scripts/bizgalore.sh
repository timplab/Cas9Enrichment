#!/bin/bash

#this scrip takes 3 inputs:
# $1 = sampleId
# $2 = outputdiR
# $3 = tempDir (with the trimmed reads)


if [ -z "$1" ]; then
    echo $1
    echo "No fastq pattern selected"
    exit 1
else 
    samp=$1
fi

outdir=$2
tempdir=$3

#this should point to a folder with
#the ref genome as a single indexed fasta 
#also should be a subfolder with the bisulfite converted genome
ref_genome=/mithril/Data/NGS/Reference/human38

#    --score_min L,0,0 \

~/dl/Bismark/bismark --bam --bowtie2 \
    -p 2 $ref_genome \
    --non_directional \
    -1 ${tempdir}/*val_1.fq.gz \
    -2 ${tempdir}/*val_2.fq.gz \
    -o ${outdir}/${samp} &> ${outdir}/${samp}/${samp}_bismarklog
