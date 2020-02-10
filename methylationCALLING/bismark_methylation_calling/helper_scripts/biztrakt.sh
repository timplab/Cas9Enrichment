#!/bin/bash

#this performs the extraction.. just takes two inputs:
# $1 = sampleID
# $2 = output_dir


##fastq pattern
if [ -z "$1" ]; then
    echo $1
    echo "No fastq pattern selected"
    exit 1
else 
    samp=$1
fi

outdir=$2
ref_genome=/mithril/Data/NGS/Reference/human38

~/dl/Bismark/bismark_methylation_extractor -p --multicore 8 --gzip --comprehensive \
    --genome_folder $ref_genome \
    --bedGraph --counts --cytosine_report \
    ${outdir}/${samp}/${samp}*_namesort.bam \
    -o ${outdir}/${samp} --no_header \
    &>${outdir}/${samp}/${samp}_extractlog



#rm -R ${scratchloc}
