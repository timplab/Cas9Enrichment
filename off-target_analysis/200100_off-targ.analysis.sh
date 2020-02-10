#!/bin/bash 
## this script 
  # (1) filters input bam for only primary alignments, 
         # or alternatively , as i found  was beneficial for BRCA1 alignments, filters for only uniquely mapped reads
	 # using samtools  (note we are using the raw alignment files output by  minimap2 .. not the filtered ones) 

  # (2)  Generates per nt coverage data genome wide  
           # also using samtools   

  # (3)  clusters coverage data using provided thresholds
           # using SURVIVOR (https://github.com/fritzsedlazeck/SURVIVOR)

datdir=path_to_bam_folder

#declaring an array with  each of the experiments
declare -a arr=( exp1  exp2  )

for samp in ${arr[@]}
  do 

    inbam=$datdir/$samp*.bam
    outd=$datdir/filter
    cov=$outd/${samp}_depthCOV.cov 

    #this filters for primary alignments in a bam file  
      #  (  -F == exclude,  0x904  = non-priamry alingments and non-aligned )   
    if false; then
      echo 'taking only primary alignments, with  qual filtering (min MAPQ 22) '
      outbam=$outd/${samp}_prim.min22.bam

      samtools view -F 0x904 -q 22  $inbam  -h -o $out/${samp}_prim_ALL.bam 
      samtools index $outbam
    fi

    #when a read aligns equally to two places, "primary" alignment is arbitrary , 
      # ergo,  when dealing with repetitive regions (eg BRCA1), i found it more benefiial instead to only select for uniquely mapping reads ..
       # as done here : 
    if false; then
      echo 'taking only uniquely mapping reads'
      outbam=$outd/${samp}_unique.bam

      samtools view -h $inbam | grep -v -e 'XA:Z:' -e 'SA:Z:' | samtools view -b > $outbam
      samtools index $outbam
    fi

    #collecting coverage data
    if false  ; then
       echo 'starting coverage analysis'
       samtools depth $outbam  >  $cov  
    fi

    #this last bit makes a bed of regions with coverage at least 25, with bins ar least 1000 nt away from one another
    if false  ; then 
       echo 'starting bincov clustering'
       path_to_SURVIVOR bincov $cov 1000 25  >  $outd/${samp}_SURVbincov.bed 
    fi

  done
