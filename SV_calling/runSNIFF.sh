#!/bin/bash -l

######
# this code is for running the NGLMR aligner followed by the Sniffles SV caller
#
#hg38referenc

#ref=/mithril/Data/NGS/Reference/human38/GRCH38.fa
#fqdir=/kyber/Data/Nanopore/projects/cas9enrich
outdir=/kyber/Data/Nanopore/Analysis/gilfunk/3deLz_gm12878/ontarg_BAMs_keepSecondary_nglmr
#/kyber/Data/Nanopore/Analysis/gilfunk/breastPanel/


declare -a arr=("3SV_gm12878")

for samp in ${arr[@]}

do

echo $samp


#running NGLMR
if false; then 
    fq=$fqdir/$samp*fastq.gz
    echo 'this is input fastq'
    echo $fq
    echo 'startin NGLMR aligner'
    ~/code/ngmlr-0.2.7/ngmlr -t 4 -r $ref -q $fq -o ${outdir}/${samp}.sam -x ont
fi


# sorting and saving NGLMR output 
if false; then 
    insam=$outdir/$samp*sam
    echo 'this is input sam' 
    echo $insam 
    echo 'sorting sam file into a bam file'
    samtools sort $insam -o $outdir/${samp}_sorted.bam
    echo 'indexing dat bam babbyyyy' 
    samtools index $outdir/${samp}_sorted.bam
fi 

#Running SNIFFLES variant caller 
#  (minimum size 100nt)
if true; then 
    srtdbam=$outdir/${samp}_*.bam
    echo 'this is input bam'
    echo $srtdbam

    /home/gilfunk/code/Sniffles-master/bin/sniffles-core-1.0.11/sniffles  --genotype  \
     --min_homo_af 99.99999 -m $srtdbam -v $outdir/sniffles_out/${samp}_genotype_minHomo999.vcf -l 100

fi

done
