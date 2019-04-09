#!/bin/bash 
## this script 
  # (1) filters input bam for only primary alignments, 

  # (2)  [optional] collects reads NOT within the guideRNAs regions to an off-target bam file 

  # (3)  Generates per nt coverage data 

  # (4)  clusters coverage data using provided thresholds  


datdir=/kyber/Data/Nanopore/Analysis/gilfunk/breastPanel/off-targ

crFlankBed=/kyber/Data/Nanopore/Analysis/gilfunk/breastPanel/off-targ/breastPanel_20kbFlank.bed

inbam=/kyber/Data/Nanopore/Analysis/gilfunk/breastPanel/rawbams_mm2/190125_breastPanel_gm12878_FriREDO_hg38.bam
#/kyber/Data/Nanopore/Analysis/gilfunk/breastPanel/off-targ/mdaMB231_wholeGenome_primARYalign.bam


mkdir $datdir/gm12878


#this filters for  primary alignments in a bam file  
#  (  -F == exclude,  0x904  = non-priamry alingments and non-aligned )   
if true; then
echo 'taking only primary alignments, with  qual FILTERING of alignments'
samtools view -F0x904 -q 30  $inbam -h -o $datdir/gm12878/gm12878_prim_minQ30_wholeGen.bam
samtools index $datdir/gm12878/gm12878_prim_minQ30_wholeGen.bam
fi



## this works nicely--  i just have this affections for Hli's tools,
# even if his documentation is often .. umm.. sparse. 

# [optional] this collects off-target reads
if false; then
samtools view  -b input_bam_file -L bed_file_with_regions -U output_off-target_bam   -h -o  output_on-target_bam
fi
#this is another way to get the  reads outside ( -v ) of the regions in the bed 
if false; then 
bedtools intersect -abam $inbam -b $crFlankBed -v > output_off-targ.bam
fi


#collecting coverage data
if true; then
echo 'starting coverage analysis'
samtools depth input_bam  >  output_perNT_COVERAGE.cov
fi

#this last bit makes a bed of regions with coverage at least 25, with bins ar least 1000 nt away from one another
if true; then 
echo 'starting bincov clustering'
/home/gilfunk/code/SURVIVOR-master/Debug/SURVIVOR  bincov perNT_COVERAGE.cov  1000 25  >  clutered_cpverage_output.bed 
fi
