#!/bin/bash


#this points to where the output files from 'trim_and_align.sh' got stored 
outdir=out_dir

if true; then 
for samp in run1 run2 run3

# I do the extraction by region,  
  # because its much faster than genome wide methylation data extraction

do
    cood="chr5:1294672-1295909"
    reg_name=name_of_region
    echo $samp
    samtools sort ${outdir}/${samp}/${samp}*bismark_bt2_pe.bam -o ${outdir}/${samp}/sorted_${samp}.bam
    samtools index ${outdir}/${samp}/sorted_${samp}.bam 
    echo "taking ROI"
    samtools view ${outdir}/${samp}/sorted_${samp}.bam ${cood} -b -o ${outdir}/${samp}/${samp}_${reg_name}.bam
    samtools sort ${outdir}/${samp}/${samp}_${reg_name}.bam  -n -o ${outdir}/${samp}/${samp}_${reg_name}_namesort.bam

    #biztrakt now looks for a file ending in "name_sort"
    echo "methylation + extraction  =  methtrakshunn"
    ./helper_scripts/biztrakt.sh ${samp} $outdir
done
fi

echo "mmmm.. Bop-methtrakshun!"
