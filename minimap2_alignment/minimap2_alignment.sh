#!/bin/bash
# script to run minimap2 alignment 

# if minimap2 index for reference does not already exist, you need to make 1  
#echo "buildin' dat index"
#~/dl/minimap2/minimap2 -d hg38.mmi hg38.fa

idx=hg38.mmi


datadir=/kyber/Data/Nanopore/Analysis/gilfunk/3deLz_gm12878/allele-assigned_fastQs
savedir=/kyber/Data/Nanopore/Analysis/gilfunk/3deLz_gm12878/allele-assigned_rawBAMs 

#mkdir -p $savedir
build=hg38

echo 'alrite we aligning now'

#all these blocked out lines are for batching 
for exp in  sequencing_run1  sequencing_run2

do
    echo $exp

    ~/dl/minimap2/minimap2 -a -x map-ont $idx $datadir/$exp*.fastq* | \
       samtools sort -T ${exp}_tmp -o $savedir/${exp}_${build}_mm2.bam

   samtools index $savedir/${exp}_${build}_mm2.bam
done

echo 'yeah bissssshhhhh' 
