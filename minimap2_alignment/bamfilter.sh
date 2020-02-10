#!/bin/bash

###########################
#  This script takes the raw bam generated from  alignment and does the following  ..... 

#    (1)  Regional filter based on a bed file 
           #    > filtering for only the regions we are interested in (flanking guideRNA sites) 
	   #         makes the bam much smaller for downloding and visualizing etc 

#    (2) Keeping only primary alignments 
           #   (discarding secondary / supplemental)

#    (3) Quality filtering of alignments, keeping only those above a certain MAPQ (20) 
############################
maindir=path_to_BAM_folder

indir=$maindir/rawbams

outdir=$maindir/prim_onTarg
mkdir -p $outdir

filterTag=prim_onT
region_bed=/path_to_bedfile/flankingRegions.bed

echo 'using this region file'
echo $region_bed

declare -a arr=( exp1   exp2   )

for samp in ${arr[@]}

do 

    echo '+++++++++++++++++++'
    echo 'making this new bam'
    outbam=$outdir/${samp}_$filterTag.bam
    echo $outbam

    # DECLARATION
    echo $samp
    inbam=$indir/$samp*bam
    echo 'this is input bam'
    echo $inbam

    if true ; then 
       echo 'starting regions and secondary alignment removal'
       samtools view -F 0x904  -q 20  -L $region_bed  $inbam -h -o $outbam 
       echo 'indexing BAM file'
       samtools index $outbam
    fi
done 
