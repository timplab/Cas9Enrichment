#!/bin/bash 

## this script takes an input vcf (eg from the platinum genome data set as shown here) 
  ## it then only pulls out variants that occur within a defined bed file 
     # this was done both to have a smaller file to work with and to make easier comparison against called variants

in_vcf=/kyber/Data/Nanopore/Analysis/gilfunk/pg2017/hg38/hybrid/hg38.hybrid.vcf
outdir=/path_to_save_dir
#mkdir -p $outdir
    #this is where the region list is AND where files will get saved to ..

roi_bed=path_to_bed_filed.bed
out_name=bed_descriptor

    echo 'here is the big file we pulling varints from'
     echo $in_vcf
    echo 'using this file for regions of interest'
     echo $roi_bed

 # if for some reason your vcf file is not sorted, here is a way to do that ( i think it has to be bgzipped and indexed for this to work ) 
 if false; then 
   echo 'sorting the vcf'
   bcftools sort -O v $in_vcf -o $full_vcf_dir/merged_Gm12878_SORTED.vcf
 fi

 #here is how  u could bgzip n index the vcf 
  if false; then 
     echo 'bgzipping the vcf' 
     bgzip $in_vcf
     echo 'indexing the vcf'
     bcftools index $in_vcf.gz
  fi

 # performing the regional extraction (note the '.gz' got added in the line above during zipping )  
  if false ; then
      echo "taking regions of interest from vcf" 
      bcftools view $in_vcf.gz  -R $roi_bed  -o $outdir/$out_name.vcf
  fi

