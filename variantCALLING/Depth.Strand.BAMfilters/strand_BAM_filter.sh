#!/bin/bash

## This script takes as input an indexed bam file (generally, already filtered for regions of interest and with only primary alignments ) 
  ## and then produces output bams with only alignments to the forward strand or reverse strand 
# while its at it.. it also counts how many reads on each strand 

maindir=/path_to_bam_folder

out=$maindir

##########
#strand Filtering 
for samp  in  exp1 exp2
   do

    echo '++++++++++++++++++++++++'
    echo $samp

     inbam=$maindir/$samp*onTarg.bam
      echo 'this is input bam'
      echo $inbam

  if true; then 

     echo 'total lines in inbam'
     samtools view $inbam | wc -l

     echo 'filtering bams for only positive strand reads'
        # "-F" means only include reads with NONE of these flags and "20" means ReverseStrand+UNmapped
	#	( so this could have also have used the "16" flag.. but i got this code from stackOverflow, where the blind lead the blind)     
     samtools view -F 20 $inbam -h -o $out/${samp}_fwd.bam
     echo 'total pos str reads'
     samtools view $out/${samp}_fwd.bam | wc -l 

     echo 'filtering bam for reverse strand reads' 
     samtools view -f 16 $inbam -h -o $out/${samp}_rev.bam
        #  "-f" means only include include reads with ALL of these flags, and "16" means ReverseStrand 
     echo 'total rev str reads' 
     samtools view $out/${samp}_rev.bam | wc -l
 
     echo 'indexing forward reads'
     samtools index $out/${samp}_fwd.bam
     echo 'indexing reverse reads'
     samtools index $out/${samp}_rev.bam
fi
   done 
