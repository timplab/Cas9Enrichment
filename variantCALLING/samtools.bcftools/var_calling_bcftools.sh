#!/bin/bash 

# script for calling variants using SAMTOOLS /  BCFTOOLS 
  # note, this takes some time to run and is a bit computationally intensive 

# this script is set up to already have bam files that are split into varying coverage (25x,50x,100x,200x,300x) 
 # AND  have each of those bam files split for 'both-strands', 'fwd-strand' & 'rev-strand' ) 
 # [[  see other scripts for splitting bam files by strand and subsampling for coverage  ]] 

# if you want the script on only one bam just use those last couple of lines. cool . pz . 
# Then for each of those bam files, (15 in total) it calls  variants as compared with a provided reference (Hg38) 

ref=/mithril/Data/NGS/Reference/human38/GRCH38.fa 
reg_bed=/path_to_bedfile.bed

##### before you run this again :: take out the unused $samp variable from the last line 

declare -a arr=( 25 50 100 200 300  )

for cov in ${arr[@]}
do
  echo '+++++++++++++++++'
  echo $cov
  for strand in gm12878 fwd rev
    do

    echo $strand       
    bamdir=/kyber/Data/Nanopore/Analysis/gilfunk/190824_allGuidez_take2_GM12878/depth_filterd_BAMs/merged	    
     mybam=$bamdir/x$cov/*$strand*bam
   #l  /kyber/Data/Nanopore/Analysis/gilfunk/190824_allGuidez_take2_GM12878/prim_onTarg/$samp*$strand*bam
   #  echo $mybam
     outd=$bamdir/x$cov/samtoolsVAR
     mkdir -p $outd
     echo 'starting var calling with samtools/bcftools - thanks HLi'   
     bcftools mpileup -Ou -f $ref $mybam -d 2000  -R $reg_bed --threads 42 -I | bcftools call -mv -Ob -o $outd/samtoolsVAR_${cov}_${strand}.bcf  --threads 42
     bcftools view $outd/samtoolsVAR_${cov}_${strand}.bcf -o $outd/samtoolsVAR_${cov}_${strand}.vcf

     done
done 
