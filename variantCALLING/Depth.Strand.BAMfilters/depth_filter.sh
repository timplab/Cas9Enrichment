#!/bin/bash

###################################
#  DEPTH FILTERING
#
#  Ok, this was a little tedious for me to do, but i will try my best to explain : 

#      [1] first I made a bam that contained only full length reads for each region (braf/tmp2/gstp1/kras/slc12a4/tp53/krt19)
    #           I did that by requring all reads to overlap a region proximal to guideRNAs on BOTH sides 
    #  like this  :   samtools view -r chrZZ:100-150  primaryalignments.bam  -h -o  regionLEFTside.bam    (region given is left side gRNA)
    #                 then ...  samtools view -r chrZZ:1000-1050  regionLEFTside.bam  -h -o  regionFULL.bam    (region is right side) 

#      [2]  I split those bam files with reads spanning region according to the strand .. ( see the "strand_BAM_filter.sh") in this folder 
#
#      [3] based on the coverage on each of those strands in the region, i subsampled to get 150X coverage per  strand
   # like this :     samtools view -s X.YYY  region_strand.bam  -h -o  region_strand_150X.bam
         # where X =  the 'seed' (started with '0', but you have to change this everytime you subsample ) 
	    #   and 'YYY' =  the subsampling depth 

  # once i had a set of bam files,  (two for each region, both fwd and rev strand at 150X ) 
  # i used THIS script multiple times (changing seeds/depth) to subsample those .. to make per-strand of  75X ..  50X .. 25X .. 12.5X 

   #.. then after i completed the subsampling I merged all of the bams in a folder to get combined coverage (both strands)  of 300X .. 150X .. etc  
   # (script for merging is at the bottom ) 

indir=/path_to_bams/subSAMP_300xTotalCov
outdir=/path_to_bams/subSAMP_150xTotalCov
mergedir=/path_to_bams/merged
mkdir $outdir

#this number is to label the per-strand bams 
per_str_cov='75'
#this is to label merged bam
total_cov='150'

# NOTE NOTE NOTE : the number on LEFT side of decimal is seed : needs to be changed everytime you subsample 
declare -a sub=( 'gpx1|1.5' \
'braf|1.5' \
'tpm2|1.5' \
'gstp1|1.5' \
'kras|1.5' \
'slc12a4|1.5' \
'tp53|1.5' \
'krt19|1.5'  )

echo '++++++++++++++++++++++++++' 
echo 'forward strand'
for loc in ${sub[@]}
do
       gene=$(echo $loc |  awk '{split($0,tings,"|"); printf tings[1]}')
       echo $gene
       inbam=$indir/fwd*$gene*bam
       outbam=$outdir/fwd_${gene}_$per_str_cov.bam
       sub_frq=$(echo $loc | awk '{split($0,tings,"|"); printf tings[2]}')
       echo $sub_frq
       samtools view -s $sub_frq $inbam -h -o $outbam
       samtools index $outbam 
done

echo '++++++++++++++++++++++++++' 
echo 'reverse strand'
for loc in ${sub[@]}
do
       gene=$(echo $loc |  awk '{split($0,tings,"|"); printf tings[1]}')
       echo $gene
       inbam=$indir/rev*$gene*bam
       outbam=$outdir/rev_${gene}_$per_str_cov.bam
       sub_frq=$(echo $loc | awk '{split($0,tings,"|"); printf tings[2]}')
       echo $sub_frq
       samtools view -s $sub_frq $inbam -h -o $outbam
       samtools index $outbam
done

ins=$(echo $outdir/*bam)
merged_bam=$mergedir/experiment_${total_cov}.bam
echo 'merging  BAMs'
samtools merge $merged_bam $ins  
echo 'indexing bam'
samtools index $merged_bam


