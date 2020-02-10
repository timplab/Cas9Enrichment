#!/bin/bash

###################
#   This script take an input set of varaints (vcf file) 
#     and converts a bam file to have only those variants present in the bam file  (using experimental nanopolish module) 
#       .This is  useful tool for visualizing variants in otherwise noisy nanopore data 
#


#here we declare an array for all of the samples  
outd=/kyber/Data/Nanopore/Analysis/gilfunk/190921_mostLYfresh/

declare -a arr=( sample1 sample2   )
# i have subfolders of the /data folder named by those elements of the array
 
for samp in ${arr[@]} 
do

   # DECLARATION 
   echo $samp

   fq=path_to_fastq.fq
   vcf=path_to_vcf.vcf


   for hap in hap1 hap2
     do


       inbam=$bamdir/${samp}/$samp*$hap.bam

       outname=${samp}_$hap
       outbam=$outd/${outname}_phazedNpVariants.bam

       np=/home/gilfunk/code/nanopolish/nanopolish
       ref_fa=/mithril/Data/NGS/Reference/human38/GRCH38.fa


      if true; then
         echo 'starting phasing'
         $np phase-reads -t 36 -r $fq -b $inbam \
           -g $ref_fa  $vcf  | samtools view -b - | samtools sort -o  $outbam
         echo 'indexing phased bam'
         samtools index $outbam
      fi
     done 
done
