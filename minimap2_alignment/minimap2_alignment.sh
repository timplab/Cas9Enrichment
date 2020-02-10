#!/bin/bash

################
# script to run minimap2 alignment to reference genome 

# if minimap2 index for reference does not already exist, you need to make one
# here is example of how to build minimap2 index (.mmi) from a reference fasta (.fa)
#echo "buildin' dat index"
#~/dl/minimap2/minimap2 -d hg38.mmi hg38.fa

idx=hg38.mmi

datadir=/path_to_fastQs
savedir=/path_to_output_directory

#mkdir -p $savedir
build=hg38

echo 'alrite we aligning now'

#all these blocked out lines are for batching 
for exp in  seq_run1  seq_run2

do
    echo $exp

    ~/dl/minimap2/minimap2 -a -x map-ont $idx $datadir/$exp*.fastq* | \
       samtools sort -T ${exp}_tmp -o $savedir/${exp}_${build}_mm2.bam

   samtools index $savedir/${exp}_${build}_mm2.bam
done

echo 'yeah baaiiyybieee' 


