#!/bin/bash

##### welcome to  my  code
# # 
#   This code is for calling single nucleotides variants with nanopolish
#      It assumes you have already split the bam files for strand (fwd, rev, both) 
#    and then calls variants over regions specified within the code below . 
#  There are several blocks of code to this monster, separated by "if True.. " statements 
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
   np=nanopolish

   #hg38_ref 
   ref_fa=/mithril/Data/NGS/Reference/human38/GRCH38.fa


    #naming  outfiles and where they will go 
    outname=nanoPOL.variants_$samp
    # this analysis directory get created during variant calling  
    anal=$outmain/$outname 

################
### INDEX  INDEX INDEX
#####################
   #first  index the fast5s for access by nanopolish
   if false; then
      echo 'starting fast5 indexing'
      ${np} index -d $f5 -s $summary $fq
   fi



  #here we delcare an array 
  # with the regions to interrogate  (region btwn the guideRNAs)
    ## updated aug 28 2019 to account for newer guides    
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

######################   
# #   Calling varaints  
######################

    if false; then

          #mkaing the directory to save variant calls  
          mkdir -p $anal

           minFrq=0.2
           echo 'this is min freq'
           echo $minFrq

	   #### iterating over the regions 
           for locus in ${regions[@]}
          do

    # call variants for reads from both strands (gm12878, or howvere you named it ), forward strand (fwd), &  reverse strand (rev) 
              for strand in gm12878 fwd rev
              do
                 inbam=$maind/$samp/*$strand*bam
                 echo $strand
                 echo $locus   
                 echo 'starting variant calling ... SNPs only..  methylation YES-AWARE'
                 ${np} variants -t 22 -d 5 -x 10000  -m $minFrq --methylation-aware=cpg --snps \
                   -r $fq -b $inbam -g ${ref_fa} \
                   --ploidy=2 -w $locus > $anal/${samp}_${locus}_NPvar_$strand.vcf
              done
         done
       fi


##############
#   Zipping vcf's 
##############
  # here im bgzipping and indexing the regional vcf variant calls for easy combining in the next step 

       if false; then 
          echo 'bgzippin and indexing the vcf files'
         for locus in ${regions[@]}
          do
              echo $locus
              for strand in gm12878 fwd rev
              do   
                 echo $strand 
                 bgzip $anal/${samp}_${locus}_NPvar_$strand.vcf
                 bcftools index  $anal/${samp}_${locus}_NPvar_$strand.vcf.gz

             done 
          done
       fi

##################
#   Combining regional vcf files into a 'COMBINED' vcf file 
#############
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
