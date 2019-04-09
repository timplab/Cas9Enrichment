#!/bin/bash 


outd=/data/gm12878/8_sites/bcfcalls


bcftools mpileup -Ou -f /data/GRCH38.fa /data/gm12878/gm12878_prim_filt_onTarg.bam  -d 1500 -R /data/8_sites/8_guides_NOdels.bed  --threads 25 -I | bcftools call -mv -Ob -o $outd/onTarg_8sites_bcfcalls.bcf  --threads 25

bcftools view $outd/onTarg_8sites_bcfcalls.bcf -o $outd/onTarg_8sites_bcfcalls.vcf


