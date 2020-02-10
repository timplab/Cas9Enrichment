#!/bin/bash 

ref=/mithril/Data/NGS/Reference/human38/GRCH38.fa

declare -a regions=( \
   'chr3:49352623-49366169' \
   'chr7:140775214-140787552' \
   'chr9:35677525-35697166' \
   'chr11:67577032-67594247' \
   'chr12:25237978-25254719' \
   'chr16:67952369-67976758' \
   'chr17:7666465-7682126' \
   'chr17:41517522-41535711' \
) # 


for cov in 25 50 100 200 300

do

if false; then
  covdir=/kyber/Data/Nanopore/Analysis/gilfunk/190824_allGuidez_take2_GM12878/depth_filterd_BAMs/merged/x$cov 
  for strand in fwd rev both 
     do 
 
          inbam=$covdir/*X${cov}_$strand.bam
          echo 'inbam:'
          echo $inbam
          for reg  in ${regions[@]}
             do 
              outd=medaka_calls/${cov}/$strand/$reg
              echo 'running medaka variant calling'
              medaka_variant -r $reg -f $ref -i  $inbam -t 8 -o  $outd   > medaka_var.vcf 
             done 
   done 
fi 

if false; then 
  for strand in fwd rev both
     do
       echo 'combining all the regional calls into _COMBINED file'



    bcftools concat  \
       medaka_calls/${cov}/$strand/chr3:*/round_1_phased.vcf.gz \
       medaka_calls/${cov}/$strand/chr7:*/round_1_phased.vcf.gz \
       medaka_calls/${cov}/$strand/chr9:*/round_1_phased.vcf.gz \
       medaka_calls/${cov}/$strand/chr11:*/round_1_phased.vcf.gz \
       medaka_calls/${cov}/$strand/chr12:*/round_1_phased.vcf.gz \
       medaka_calls/${cov}/$strand/chr16:*/round_1_phased.vcf.gz \
       medaka_calls/${cov}/$strand/chr17:766*/round_1_phased.vcf.gz \
       medaka_calls/${cov}/$strand/chr17:415*/round_1_phased.vcf.gz \
             -o medaka_calls/${cov}_${strand}_COMBINED.vcf
    done
fi


done
