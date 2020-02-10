#!/bin/bash

#this script takes a set of reads as input and uses them to build a draft assembly 
#( i  used reads which aligned to the BRCA1 locus which had aleady been seggregated into haplotypes using watsHap)

#usage: flye (--pacbio-raw | --pacbio-corr | --nano-raw |
#	     --nano-corr | --subassemblies) file1 [file_2 ...]
#	     --genome-size SIZE --out-dir PATH
#	     [--threads int] [--iterations int] [--min-overlap int]
#	     [--meta] [--plasmids] [--no-trestle] [--polish-target]
#	     [--debug] [--version] [--help] [--resume] 
#	     [--resume-from] [--stop-after]


maindir=path_to_data
fl=path_to_fly 

for allele in hap1  hap2 
 do 

   input_fq=$maindir/*$allele.fastq
   output_dir=$maindir/flye_assembl/$allele
   mkdir -p $output_dir
   echo $allele
   echo $input_fq
   echo 'starting to get FLYEEEEE'
   
   $fl  --nano-raw $input_fq --genome-size 85k --out-dir $output_dir --threads 22
 
 done
