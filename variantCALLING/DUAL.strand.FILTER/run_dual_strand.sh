#!/bin/bash 

# # DUAL STRAND FILTERING 
#
#  prior to running this you need to  : 
#            [1] split bam files by strand 
#            [2] call variants on each of the 3 bam files (fwd, rev + both) 

# $anal should point to folder with analysis from variant calls 
# you should have a vcf of variants for just forward (fwd) , just reverse (rev) , and full data ( called gm12878 in my set ) 
# the 'COMBINED' flag on the input file was added after fusing variant calls from different regions (see nanopolish variant calling scripts) 
# output file will have the 'common' flag  ( '_commonfromONTARGvariants.vcf') 

anal=/path_to_vcf_folder
# after you run the variant calling scripts described herein , 
  # you will get variants that are common to all three data sets 

echo 'finding overlaps right meoww'
    ./helper_scripts/v2_find_overlaps.py -f $anal/*COMBINED*fwd.vcf -r $anal/*COMBINED*rev.vcf -t $anal/*COMBINED*gm12878*.vcf  -o $anal/${outname}_commonfromONTARGvariants.vcf

echo 'new vcf file with common variants created' 

