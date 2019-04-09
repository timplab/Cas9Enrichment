#!/bin/bash

#can use this array to perform on multiple samples at once
declare -a arr=( 'mdamb231'   'mcf7'   'mcf10a'  )
#('mcf10a' ' Mcf7'  'gm12878' 'MdaMB231')

rawdir=path_to_raw_bams

out=save_path

region_bed=regions_to_collect.bed

for samp in ${arr[@]}
do

# DECLARATION 
echo $samp
inbam=${rawdir}/$samp/*.bam
#gm12878_prim_minQ30_wholeGen.bam

echo 'this is input bam'
echo $inbam

#strand Filtering 
if false; then
   echo 'total lines in inbam'
   samtools view $inbam | wc -l

   echo 'filtering bams for only positive strand reads'
   samtools view -F 20 $inbam -h -o $out/${samp}_fwd.bam
   echo 'total pos str reads'
   samtools view $out/${samp}_fwd.bam | wc -l 
   echo 'filtering bam for reverse strand reads' 
   samtools view -f 16 $inbam -h -o $out/${samp}_rev.bam
   echo 'total rev str reads' 
   samtools view $out/${samp}_rev.bam | wc -l
 
   echo 'indexing forward reads'
   samtools index $out/${samp}_fwd.bam
   echo 'indexing reverse reads'
   samtools index $out/${samp}_rev.bam
fi

done

