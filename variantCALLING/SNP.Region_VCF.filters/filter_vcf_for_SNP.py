#!/usr/bin/env python

# This script takes a vcf file and filters it to only contain single nucleotide variants 
# i thought i would have been able to do this using a flag, but it was not consistent between variant callers, 
 # and therefore i just made sure that the length of the variant and the length of the reference were both '1' 

# when i ran this on multiple samples at once i just added a 'for' loop. 

print( '++++++++++++++++')
inpath='/kyber/Data/Nanopore/Analysis/gilfunk/191024/Brca_regions_Hybrid.vcf'
outpath='/kyber/Data/Nanopore/Analysis/gilfunk/191024/SNPS_ONLY_Brca_reg_Hybrid.vcf'

infile=open(inpath, 'r')

outfile=open(outpath, 'w')
print('gettin dem SNPs')
for line in infile:
    if line.startswith('#'):
        outfile.write(line)
    else:
        tings=(line.rstrip()).split('\t')
        if len(tings[3]) == 1 and len(tings[4]) ==1:
            outfile.write(line)

infile.close()
outfile.close()

print('heyyyy   new vcf file with only SNPs created')
