#!/bin/bash

#this array should have elements that are subdirectories of the data folder
declare -a arr=('gm12878')
#('190120_mcf10a' '190124_Mcf7') 

for samp in ${arr[@]} 
do

# DECLARATION 
echo $samp
rawdir=/data/$samp
fq=${rawdir}/*.fastq.gz
summary=${rawdir}/*.txt 
f5=${rawdir}/*_f5
mybam=${rawdir}/*onTarg.bam
outname=$samp
anal=$rawdir/out

## 180930 :  np 10.2
np=nanopolish
#nploc=~/dl/nanopolish/

#hg19
#ref_mm=/mithril/Data/NGS/Reference/human/hg19.mmi
ref_fa=/data/GRCH38.fa

#hg38
#ref_mm=/mithril/Data/NGS/Reference/human38/hg38.mmi
#ref_fa=/mithril/Data/NGS/Reference/human38/GRCH38.fa

if true; then
 #   source activate polish
    echo 'creating folder to store nanopolish output files'
    mkdir $anal
    echo 'starting fast5 indexing'
    ${np} index -d $f5 -s $summary $fq
 #   source deactivate
fi


declare -a regions=('chr17:7666028-7682126')
#rn just TP53 region

#'chr3:49332525-49386169' 'chr9:35657525-35717166' \
#'chr11:67556428-67614247' 'chr16:67932369-67996758' \
# 'chr17:41497522-41555711' )

if false; then
    for locus in ${regions[@]}
    do
    
    echo 'starting meth call'
    echo $locus 
    
    ${np} call-methylation -t 8 -r $fq -b $mybam  -g ${ref_fa} -w $locus  > ${anal}/${outname}_${locus}_methcalls.tsv
    done
fi


#use this bit to combine together meth calls across multiple regions
 # requires you have first copied the heder line from meth calls 
 #into this 'methcalls_header.tsv'
if false; then
    echo 'removing headerlines'
    sed -i '/^chromosome/d'  ${anal}/${outname}_*_methcalls.tsv
    echo 'catting together methcalls'
    cat methcalls_header.tsv ${anal}/${outname}_chr3:*_methcalls.tsv \
	   ${anal}/${outname}_chr9:*_methcalls.tsv ${anal}/${outname}_chr11:*_methcalls.tsv \
	   ${anal}/${outname}_chr16:*_methcalls.tsv ${anal}/${outname}_chr17:*_methcalls.tsv \
	   > ${anal}/${outname}_COMBINED_methcalls.tsv
fi 

if false; then
    thresh=2.5
    echo 'calling meth freq using a threshold of:'
    echo $thresh
    mcalls=${anal}/${outname}_COMBINED_methcalls.tsv
    # the next script here is from the nanopolish supplementary scripts
    ~/calculate_methylation_frequency.py -i $mcalls -c $thresh  > ${anal}/${outname}_thrsh${thresh}_mFREQ.tsv

fi

done
