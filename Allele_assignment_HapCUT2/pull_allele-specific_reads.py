#!/usr/bin/env python


#ase_calls == annotatedHAIRS file 
ase_calls='annotated_frag_file'
inbam =  'input_bam_file'
outd = 'where_to_save'

import re
import os
import argparse
import gzip
from Bio import SeqIO
import pysam

mat_IDs = []
pat_IDs = [] 
hair=open(ase_calls, 'r')
print('collecting read names from HAIRS file')
for line in hair:
  #  print('xxx')
    stuff=(line.rstrip()).split('\t')
    if stuff[-1] == 'P':
        pat_IDs.append(stuff[1])
    if stuff[-1] == 'M':
        mat_IDs.append(stuff[1])
hair.close()

#remove any cases where a read was assigned to both. it's weird , but it can happen with secondary alignments
for i in mat_IDs:
    if i in pat_IDs:
        print( 'wtf?')
        print( i) 
        mat_IDs.remove( i )
        pat_IDs.remove( i ) 
mat = set ( mat_IDs)
pat = set ( pat_IDs)

print('this many maternal reads')
print(len(mat))
print('this many paternal reads')
print(len(pat)) 


#make sam files with reads from each parental allele 
bamfile = pysam.AlignmentFile(inbam, "rb")
out_mat = open(outd+'/maternal_tmp.sam', 'w')
out_pat = open(outd+'/paternal_tmp.sam', 'w')

for read in bamfile.fetch():
    if read.qname in mat:
        out_mat.write(read.to_string()+'\n')
    if read.qname in pat:
        out_pat.write(read.to_string()+'\n')

bamfile.close()

out_mat.close()
out_pat.close()

