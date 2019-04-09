#!/bin/bash

#where is the data to analyze?
rawdir=input_dir

#where u wanna save alignment data ? (root only )
outdir=save_dir
#rm -rf $outdir
#mkdir -p $outdir

#for the 'samp' add the 
  #run  IDs, separated by spaces:::
for samp in samp01 samp02 
 
do
    echo $samp
    echo "time to trimmm"
    ./helper_scripts/trim.sh $rawdir ${samp} $outdir

#bizgalore.sh assumes script above used to specify temp dir of the trimmed files  
    echo "aligning up in this bisssssh"
    ./helper_scripts/bizgalore.sh ${samp} $outdir ${outdir}/${samp}/temp
    
done

echo "it looks like we made it"
