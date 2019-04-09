#!/bin/bash


# this is to make heterozygous SNP only vcf:
#bcftools view -g het hg38.hybrid.vcf.gz -O v -o Na12878het.vcf


#with single reads flag 
#/usr/local/bin/extractHAIRS --nf 1 --singlereads 1  --ont 1 --bam /kyber/Data/Nanopore/Analysis/gilfunk/breastPanel/filt_nglmr_keepSecondary/gm12878_withSecondary_onTarg.bam  --VCF Na12878het.noheader.vcf  --out /kyber/Data/Nanopore/Analysis/gilfunk/breastPanel/190329_allele/gm12878_onTarg10_keep2nd_nglmr_extractHairs  --ref /mithril/Data/NGS/Reference/human38/GRCH38.fa

#without single reads
/usr/local/bin/extractHAIRS --nf 1  --ont 1 --bam /kyber/Data/Nanopore/Analysis/gilfunk/Xist_redo/Na12878_dedup_hg38_XISTtarg.bam  --VCF Na12878het.noheader.vcf  --out /kyber/Data/Nanopore/Analysis/gilfunk/Xist_redo/Na12878_dedup_hg38_Xist_extractHAIRS  --ref /mithril/Data/NGS/Reference/human38/GRCH38.fa

