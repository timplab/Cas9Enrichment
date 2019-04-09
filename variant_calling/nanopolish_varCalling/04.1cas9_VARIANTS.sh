#!/bin/bash

##### welcome to  my  code babbyyyyyy
# i dont pretend im the best at this.. 
# is there a way to do  this better ?  ya probably
#
#   but this works .. so there u go.   thats where we at. 
#  my email is tgilpat1   < at  >   jhmi  (dot)  edu
# 
#    <3  gilfunk 


#here we declare an array for all of the samples  
declare -a arr=('mdamb231' )
# i have subfolders of the /data folder named by those elements of the array

#this assumes we have 3 bams for the samples
 # the 'onTarg' (all alignments)
 # the 'fwd' (only alignments to forward strand) 
 # the 'rev' (only alignments to reverse strand) 
   #these titles should be at the end of the bam filename 

for samp in ${arr[@]} 
do

# DECLARATION 
echo $samp
rawdir=/data/$samp
fq=${rawdir}/*.fastq.gz
summary=${rawdir}/*SUMMARY.txt
f5=${rawdir}/*_f5

np=nanopolish

#hg38_ref 
ref_fa=/data/GRCH38.fa

#how we want to save outfiles and where they will go 
outname=out
anal=$rawdir/$outname

#each of the following sections can be run separately...
  # or all at one go by making all sections as  'true' 

#first we  index the fast5s for access by nanopolish
if false; then
    echo 'creating folder to store nanopolish output files'
#    mkdir $anal
    echo 'starting fast5 indexing'
    ${np} index -d $f5 -s $summary $fq
fi

#here we delcare an array 
   # with the regions to interrogate 
    # for variant calling i have it using the region btwn the guideRNAs 
declare -a regions=( \
        'chr7:140775214-140787552' \
        'chr12:25237978-25254719' \
	'chr17:7666028-7682126' \
	)
#'chr3:49352525-49366169' \
#'chr7:140775214-140787552' \
#'chr9:35677525-35697166' \
#'chr11:67576428-67594247' \
#'chr12:25237978-25254719' \
#'chr16:67952369-67976758' \
#'chr17:7666028-7682126' \
#'chr17:41517522-41535711' \
# )


if false; then
#Calling varaints  
#    mkdir $anal
    for locus in ${regions[@]}
    do

  
  # call variants for reads from both strands (onTarg)    
    # as well as forward strand only (fwd)  
    # and reverse strand only (rev) 
    # the ' -m '  flag is where we set the minimum frequency threshold for a vairant 
    
    for strand in onTarg fwd rev
      do
         inbam=$rawdir/*$strand*bam
         echo $inbam
         echo $locus   
         echo 'starting variant calling ... SNPs only..  methylation YES-AWARE'
         ${np} variants -t 50 -d 10 -m 0.25 --methylation-aware=cpg --snps \
         -r $fq -b $inbam -g ${ref_fa} \
         --ploidy=2 -w $locus > $anal/${outname}_${locus}_variants_$strand.vcf
      done
    done
fi


if false; then 
    echo 'bgzippin and indexing the vcf files'
    for locus in ${regions[@]}
       do
          echo $locus
          for strand in onTarg fwd rev
          do   
              echo $strand 
              bgzip $anal/${outname}_${locus}_variants_$strand.vcf
              bcftools index $anal/${outname}_${locus}_variants_$strand.vcf.gz
          done 
       done
fi

if false; then
    echo 'combining vcf files'
    for strand in onTarg fwd rev
    do
       echo $strand 
       
       #alrite , so this is ugly .. i admit
        # i did it this way to  keep the variants in order . 
	   # i guess you could also cat together all the vcf.gz
	     #  files then sort them .    idk maybe there is 
	     # some reason i did it this way i cant remember kay byeeeeee
       bcftools concat  \
               ${anal}/${outname}_chr7:*$strand.vcf.gz \
	       ${anal}/${outname}_chr12:*$strand.vcf.gz \
               ${anal}/${outname}_chr17:*$strand.vcf.gz \
                -o ${anal}/${outname}_COMBINED_variants_$strand.vcf
   done
#	     ${anal}/${outname}_chr3:*$strand.vcf.gz \
#             ${anal}/${outname}_chr7:*$strand.vcf.gz \
#             ${anal}/${outname}_chr9:*$strand.vcf.gz \
#             ${anal}/${outname}_chr11:*$strand.vcf.gz \
#             ${anal}/${outname}_chr12:*$strand.vcf.gz \
#             ${anal}/${outname}_chr16:*$strand.vcf.gz \
#             ${anal}/${outname}_chr17:766*$strand.vcf.gz \
#	     ${anal}/${outname}_chr17:415*$strand.vcf.gz \
#            -o ${anal}/${outname}_COMBINED_variants_$strand.vcf
#    done
fi


if true; then
echo 'finding overlaps right meoww'
    ./find_overlaps.py -f $anal/*fwd.vcf -r $anal/*rev.vcf -t $anal/*onTarg.vcf  -o $anal/${outname}_commonToBoth.vcf
fi


#truth_vcf=/data/3_SV_gm12878/pg2017_vcf/pg2017_Hybrid_3SV_btwnGuides.vcf
#mybam=/data/3_SV_gm12878/3SV_gm12878_withSecondary_onTarg.bam
#this last bit is used to remove errors not included in an input vcf, to perform 'phasing'  of bam files 
  # to facilitate visualizatioNN
if false; then
    echo 'starting phasing'
    ${np} phase-reads -t 36 -r $fq -b $mybam \
    -g ${ref_fa} $truth_vcf | samtools view -b - | samtools sort -o $anal/${outname}_TRUTHphase.bam
    samtools index $anal/${outname}_TRUTHphase.bam
fi

done
