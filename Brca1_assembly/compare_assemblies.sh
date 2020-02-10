#!/bin/bash 

# this script takes two fasta files (in case of paper, BRCA1 assemblies) 
 # and reports all differences between the two sequences  

#note that assemblies can sometimes assemble regions 3'>5' instead of 5'>3' 
 #.. in such case you should reverse one of them prior to comparing.. eg using seqtk: 
#seqtk seq -r in.fq > out.fq

 
#running this requires cloning from the minimap2 gitRepo as well as installing the k8 javascript shell 
# see instruction for doing that here: 
#   https://github.com/lh3/minimap2/tree/master/misc  

#this is needed if k8, minimap2, or the paftools.js script are not in the path 
export PATH="$PATH:`pwd`:`pwd`/misc"


main=/path_to_assemblies_folders
hap1_fa=$main/hap1/hap1_MDKconsensus.fasta
hap2_fa=$main/hap2/hap2_MDKconsensus.fasta

pftoo=/path_to_paftools/paftools.js
minimap2 -c --cs $hap1_fa $hap2_fa | sort -k6,6 -k8,8n | $pftoo call -L15000 -

