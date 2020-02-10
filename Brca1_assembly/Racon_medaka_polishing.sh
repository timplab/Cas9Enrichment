#!/bin/bash 

##### This script performs four rounds of polishing with racon 
# followed by one round of polishing with medaka 

maind=path_to_draft_assembly_folder

for hap  in  allele1 
do
   in_fq=$maind/CHOZNStableNoglnDay0rep3_both.min300nt.fastq
#    echo $fq

   #4 rounds of racon polishing
     # (draft assembly should be in folder 'maind/0' 
     # this makes folders '1,2,3,4' ) 
if false; then 
   for iter in 0 1 2 3
  do
    ind=$maind/$iter
    assbl_in=$ind/$hap*.fa
    idx=$ind/${hap}_$iter.mmi
    iter_out=`echo "$iter + 1" | bc`

    outd=$maind/$iter_out
    mkdir -p $outd


   #### indexing and alingment    
    echo 'making minimap index of assembly'
    minimap2 -d $idx $assbl_in

    outbam=$outd/${hap}_idx${iter}_mm2.bam
    outsam=$outd/${hap}_idx${iter}_mm2.sam
    #    echo $outbam
    echo "alignin' up in this"
    minimap2 -a -x map-ont  -t 33  $idx $in_fq | \
        samtools sort -T ${hap}_${iter}_tmp -o $outbam

    echo "indexng bam file"
    samtools index $outbam
    samtools view $outbam -h -o $outsam

   ### racon polishing 
    assbl_out=$outd/${hap}_iter${iter_out}_assembly.fa

    rcn=/usr/local/bin/racon 
#    assbl_out=$outd/${hap}_iter${iter_out}_assembly.fasta
    $rcn  -m 8 -x -6 -g -8 -w 500  $in_fq $outsam $assbl_in  > $assbl_out
       # m :  score for matching bases (increased from default of 5) 
       # x :  score for mismatching bases (decreased from default of -4 ) 
       # g :  gap penalty (default) 
       # w :  window-length (default) 

  done
fi

# one round of medaka polishing 
if true; then 

   medaka_consensus -i $in_fq -d $maind/4/*_iter4_assembly.fa -o $maind/mdka -t 8

fi

done
