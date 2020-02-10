#!/bin/bash -l

######
# this code is for running the minimap2 aligner followed by the Sniffles SV caller
#     ..NOTE sniffles was originally designed for use with the NGMLR alignment tool ,  
   #    so when running with minimap2, you have to have use the --MD flag .. also make sure you are using the latest v. of minimap2 
            

#minimap2 index file (created with minimap2 from fasta reference) 
idx=/mithril/Data/NGS/Reference/human38/GRCH38.mmi

outdir=path_to_save 
fqdir=path_to_fastqs

declare -a arr=("mcf10a"  "mdamb231"  "mcf7" )

for samp in ${arr[@]}

do

  echo $samp

#running minimap2 alignment with the --MD flag 
  if false; then 
      fq=$fqdir/$samp*fastq.gz
      echo 'this is input fastq'
      echo $fq
      echo 'startin minimap2 alignment'
      ~/dl/minimap2/minimap2 --MD -a -x map-ont $idx $datadir/$exp*.fastq*    | \
         samtools sort -T ${exp}_tmp -o $savedir/${exp}_${build}_mm2.bam

  fi

#Running SNIFFLES variant caller 
#  (minimum size 100nt)
  if true; then 
    srtdbam=$outdir/${samp}_*.bam
    echo 'this is input bam'
    echo $srtdbam

    /home/gilfunk/code/Sniffles-master/bin/sniffles-core-1.0.11/sniffles  --genotype  \
       --min_homo_af 99.9 -m $srtdbam -v $outdir/sniffles_out/${samp}_sniffCALLS.vcf -l 50

  fi

done
