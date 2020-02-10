#!/bin/bash

#this array should have elements that are subdirectories of the 'rawdir' data folder
declare -a arr=('gm12878_flongle')

for samp in ${arr[@]} 
do

  # DECLARATION 
  echo $samp
  rawdir=/kyber/Data/Nanopore/Analysis/gilfunk/flongle_1/data

  fq=${rawdir}/*.fastq.gz
  summary=${rawdir}/*.txt 
  f5=${rawdir}/*_f5
  mybam=${rawdir}/*onTarg.bam

  outdir=path_to_save_files 

  # this analysis dir is made during meth calling 
  anal=$outdir/methcalls_$samp

  np=~/code/nanopolish/nanopolish

  ref_fa=/mithril/Data/NGS/Reference/human38/GRCH38.fa

##############################
#### INDEXING FASTQ to FAST5
##############################
  if false; then
      echo 'starting fast5 indexing'
      ${np} index -d $f5 -s $summary $fq
   fi

# regions to call methylation in 
  declare -a regions=('chr3:49332525-49386169' \
                    'chr9:35657525-35717166' \
                    'chr11:67556428-67614247' \
		    'chr16:67932369-67996758' \
                    'chr17:41497522-41555711' )

#########################
####   CALLING METHYLATION 
##########################    
  if false; then
      
      echo 'making dir to store output'
      mkdir -p $anal 

      for locus in ${regions[@]}
      do
        echo 'starting meth calling'
        echo $locus 
    
        ${np} call-methylation -t 8 -r $fq -b $mybam  -g ${ref_fa} -w $locus  > ${anal}/${samp}_${locus}_methcalls.tsv
      done
  fi

#########################
#use block combines together meth calls across multiple regions [make sure the chromosomes are changed for YOUR region(s)]
 # requires you have first copied the header line from meth calls 
 #into this 'methcalls_header.tsv'  (or use the one provided with this script)
  if false; then
      echo 'removing headerlines'
      sed -i '/^chromosome/d'  ${anal}/${samp}_*_methcalls.tsv
      echo 'catting together methcalls'
      cat methcalls_header.tsv \
	   ${anal}/${samp}_chr3:*_methcalls.tsv \
	   ${anal}/${samp}_chr9:*_methcalls.tsv \
	   ${anal}/${samp}_chr11:*_methcalls.tsv \
	   ${anal}/${samp}_chr16:*_methcalls.tsv \
	   ${anal}/${samp}_chr17:*_methcalls.tsv \
	           > ${anal}/${samp}_COMBINED_methcalls.tsv
  fi 


##################
#
#  This calculation of methylation frequency is to call the frequency at which each CpG was methylated
#
##########
  if false; then
      mcalls=${anal}/${samp}_COMBINED_methcalls.tsv
      # the next script here is from the nanopolish supplementary scripts
      frq_script=/home/gilfunk/code/nanopolish/scripts/calculate_methylation_frequency.py
      python $frq_script  -s  $mcalls  > ${anal}/${samp}_mFREQ.tsv

  fi

done
