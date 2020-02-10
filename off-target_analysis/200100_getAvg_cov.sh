#!/bin/bash

## this script  :
  # (1) Generates per nt coverage data in provided region  
  # (2) Calculates average coverage over the region btwn inner guideRNAs 

datdir=/path_to_bam_files
#ls $datdir

declare -a arr=( seq_run1   seq_run2  )  

for samp in ${arr[@]}
   do

   echo $samp 

   inbam=$datdir/$samp*bam
   mkdir -p tmp/$samp

   ## updated oct 17 2019 with all of the latest guideRNAs .. using the inner most sites for each flank
      # no BRCA1 and for sites with deletions only looking at before/after only for the breakpoints 
    declare -a reg=(  \
      'chr5:58379389-58384150' \
      'chr5:58390270-58395287' \
      'chr7:154593967-154600407' \
      'chr7:154607987-154613978' \
      'chr7:140775214-140787552' \
      'chr11:67577032-67594247' \
      'chr3:49352623-49366169' \
      'chr12:25237978-25254719' \
      'chr17:41517522-41535711' \
      'chr16:67952369-67976758' \
      'chr17:7666465-7682126' \
      'chr9:35677525-35697166'    )

    # this bit generates a per nucleotide '.cov' file for each of the regions above 
      for site in ${reg[@]}
        do
          samtools depth $inbam  -r $site >  tmp/$samp/${samp}_${site}.cov
       done
   
    # for the two sites with deletions this bit combines the coverage from before and after the breakpoints into  a single fiLe 
       cat tmp/$samp/*chr5:583* >  tmp/$samp/${samp}_chr5_BOTHside.cov
       cat tmp/$samp/*chr7:154* >  tmp/$samp/${samp}_chr7_BOTHside.cov

 ## also updated oct 17 2019  with newer guideRNAs 
  # note now for the two deletion sites we are calling the combined file rather than on either side 
    declare -a reg2=(  \
      'chr5_BOTHside' \
      'chr7_BOTHside' \
      'chr7:140775214-140787552' \
      'chr11:67577032-67594247' \
      'chr3:49352623-49366169' \
      'chr12:25237978-25254719' \
      'chr17:41517522-41535711' \
      'chr16:67952369-67976758' \
      'chr17:7666465-7682126' \
      'chr9:35677525-35697166'    )

    # this last snippet looks at each of those '.cov' files and calculates the average coverage over each  region  
      for site2 in ${reg2[@]}
      do
	 reg_cov=tmp/$samp/${samp}*$site2.cov
         echo $site2
         awk '{ total += $3 } END { print total/NR }' $reg_cov
      done 
done 
