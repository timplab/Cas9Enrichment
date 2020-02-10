#!/bin/bash

##### welcome to  my  code babbyyyyyy
# # There are several blocks of code to this monster, separated by "if True.. " statements 
#   good luck ! 
# 
#    <3 gilfunk 



# i have subfolders of the maind .. each with a name for the individual sample 
maind=path_to_data 


declare -a arr=( samp1   samp2  )
# i have subfolders of the /data folder named by those elements of the array
 
for samp in ${arr[@]} 
do

### update all these paths so they correctly point to the:
                #  fastq (single file) 
		#  sequencing summary file (optional but it speeds up nanopolish indexing) 
		#  fast5 folder 
   echo $samp
   rawdir=$maind/$samp
   fq=${rawdir}/fq-sum_CAT/*.fastq.gz
   summary=${rawdir}/fq-sum_CAT/*.txt
   f5=$rawdir/*_fast5


 ## where files will be saved to   
   outmain=path_to_savedir/$samp

 ## path to nanopolish (if not on path)   
   np=/home/gilfunk/code/nanopolish/nanopolish

   #hg38_ref 
   ref_fa=/mithril/Data/NGS/Reference/human38/GRCH38.fa

### INDEX  INDEX INDEX #####
   #first we  index the fast5s for access by nanopolish
   if false; then
      echo 'starting fast5 indexing'
      ${np} index -d $f5 -s $summary $fq
   fi

#here we delcare an array 
# with the regions to interrogate  (region btwn the guideRNAs)

     ## updated aug 28 to account for newer guides    
    declare -a regions=( \
   'chr3:49352623-49366169' \
   'chr7:140775214-140787552' \
   'chr9:35677525-35697166' \
   'chr11:67577032-67594247' \
   'chr12:25237978-25254719' \
   'chr16:67952369-67976758' \
   'chr17:7666465-7682126' \
   'chr17:41517522-41535711' \
       )

#### this 'for loop' was for when i was subsetting files based on coverage. 
 #### for most uses you can eliminate this coverage 'for loop'
   for cov in 25 50 100 200 300
   do  
       echo '++++++++++++'
       echo 'coverage'
       echo $cov 
       #how we want to save outfiles and where they will go 
       outname=nanoPOL.variants
       bamdir=$outmain/x$cov
       anal=$bamdir/$outname 
       mkdir -p $anal
        #anal is short for analysis.  get your mind out of the gutter. 
         # thats the directory we save the analysis to


    ##################   
       #Calling varaints  
       if false; then
           minFrq=0.2
           echo 'this is min freq'
           echo $minFrq


	   #### iterating over the regions 
           for locus in ${regions[@]}
          do

    # call variants for reads from both strands (onTarg)    
    # as well as forward strand only (fwd)  
    # and reverse strand only (rev) 
              for strand in gm12878 fwd rev
              do
                 inbam=$bamdir/*$strand*bam
                 echo $strand
                 echo $locus   
                 echo 'starting variant calling ... SNPs only..  methylation YES-AWARE'
                 ${np} variants -t 22 -d 5 -x 10000   -m $minFrq --methylation-aware=cpg --snps \
                   -r $fq -b $inbam -g ${ref_fa} \
                   --ploidy=2 -w $locus > $anal/${outname}_${locus}_variants_$strand.vcf
              done
         done
       fi

      if false; then
	      for locus in ${regions[@]}
          do
        	 for strand in gm12878 fwd rev
                    do 
                     echo 'renaming files to have cov amt'
	              mv $anal/${outname}_${locus}_variants_$strand.vcf $anal/${outname}_${locus}_var${cov}X_$strand.vcf
	            done     
	  done 
     fi

     if false; then 
          echo 'bgzippin and indexing the vcf files'
         for locus in ${regions[@]}
          do
              echo $locus
              for strand in gm12878 fwd rev
              do   
                 echo $strand 
                 bgzip $anal/${outname}_${locus}_var${cov}X_$strand.vcf
                 bcftools index $anal/${outname}_${locus}_var${cov}X_$strand.vcf.gz 
             done 
          done
       fi

    # you betta make sure you have the chromosomes/regions you want below..  before you move onnnnn !!!!!!!
       if false; then
          echo 'combining vcf files'
           for strand in gm12878 fwd rev
           do
               echo $strand     
          # alrite , so this is ugly .. i admit
          # i did it this way to  keep the variants in order . 
	  # i guess you could also cat then sort.. 
 	     #    idk maybe there is some reason i did it this way i cant remember kay thx byeeeeee
               bcftools concat  \
               ${anal}/*_chr3:*$strand.vcf.gz \
                ${anal}/*_chr7:*$strand.vcf.gz \
                ${anal}/*_chr9:*$strand.vcf.gz \
                ${anal}/*_chr11:*$strand.vcf.gz \
                ${anal}/*_chr12:*$strand.vcf.gz \
                ${anal}/*_chr16:*$strand.vcf.gz \
                ${anal}/*_chr17:766*$strand.vcf.gz \
      	        ${anal}/*_chr17:415*$strand.vcf.gz \
                    -o ${anal}/${outname}_COMBINED_variants_$strand.vcf
             done
         fi
   done 

done
