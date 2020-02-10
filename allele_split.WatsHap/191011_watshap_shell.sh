#!/bin/bash 

#####
#   Script fot taking identified variants and phasing 
#      Then applying those phased varaints to split a bam file into phased bams 

# this uses  'WATSHAP'   as well as 'SAMTOOLS' and a 'HELPER SCRIPT' the subfolder associated with this script

main=/kyber/Data/Nanopore/Analysis/gilfunk/190824_allGuidez_take2_GM12878
samp=180924_allGuideMin

### this assumes you already have  a vcf file 
# this script then takes those variants in vcf and makes a phased vcf ( '|'   instead of '\' ) 
# note it can only create phased blocks in regions where it encounters read overalppning multiple variants 

in_vcf=$main/varIANT_calls/nanoP_190824_allGuidez_take2_GM12878_VARmin20/*commonfromONTARGvariants.vcf
in_bam=$main/prim_onTarg/190824_allguides_take2_gm12878_onTarg_prim.bam

out_dir=$main/watshap_nanopolish
#$main/varTISSUEnp/$samp
phased_vcf_out=$out_dir/${samp}_npSNPs_phased.vcf
tagged_bam=$out_dir/${samp}_tagged_WH.bam

ref=/mithril/Data/NGS/Reference/human38/GRCH38.fa

######################################
 ################################
# # THIS SECTION is only needed if your vcf is NOT phased --  
  # #  
if false ; then
  echo 'just you wait your pretty little self there while watsHap does its thing'
  echo 'making phased vcf'
  /home/gilfunk/.local/bin/whatshap phase  --full-genotyping  --indels --reference $ref --ignore-read-groups -o $phased_vcf_out $in_vcf $in_bam 
  # .. you need the 'ignore read groups'  or else it will look for sample tags in the bam 

  echo 'compressing vcf with bgzip' 
  bgzip ${phased_vcf_out}
  echo 'indexing vcf with tabix'
  tabix -p vcf ${phased_vcf_out}.gz

fi 

################################
### this next bit takes a 'phased' vcf, then looks at the reads once again and assigns them to a read group 

if false  ; then 
  echo 'making a new bam with haplotype tags'
  /home/gilfunk/.local/bin/whatshap haplotag  --ignore-read-groups  -o  $tagged_bam  ${phased_vcf_out}.gz  $in_bam
  echo 'indexing tagged bam file'
   samtools index $tagged_bam

   echo 'starting splitting of that bam bieebbyyyy!'  
   python helper_scripts/v2_split_BAM_by_tag.py  -b $tagged_bam  -o $out_dir  -n $samp

   echo 'indexing split  bam fileSSS'
   samtools index $out_dir/*hap1.bam
   samtools index $out_dir/*hap2.bam
fi


## this last bit is for getting fastqs for each allele for assembly and consensus 
if false ; then
   echo 'converting BAMs to Fastq'
   samtools fastq $out_dir/*hap1.bam > $out_dir/${samp}_hap1.fastq
   samtools fastq $out_dir/*hap2.bam > $out_dir/${samp}_hap2.fastq
fi


