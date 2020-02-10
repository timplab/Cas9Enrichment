#!/usr/bin/env python

import re
import os
import argparse
import gzip
from Bio import SeqIO
import pysam


def make_temp_sams(inbam, outd):
    mat_IDs = []
    pat_IDs = [] 

    bamfile = pysam.AlignmentFile(inbam, "rb")

    hap_1 = pysam.AlignmentFile( outd+ "/" + args.name + "_hap1.bam", "wb", template=bamfile)
    hap_2 = pysam.AlignmentFile( outd+ "/" + args.name + "_hap2.bam"  , "wb", template=bamfile) 
    hap_other = pysam.AlignmentFile( outd+ "/"  + args.name + "WEIRDhap.bam"   , "wb", template=bamfile)
    hap_none = pysam.AlignmentFile( outd+ "/"  + args.name + "NOhap.bam" , "wb", template=bamfile)

    for read in bamfile.fetch():
        try:
            hp=str(read.get_tag("HP"))
#            print(hp)
            if hp ==  '1' :
                hap_1.write(read)
            elif hp ==  '2' : 
                hap_2.write(read) 
            else:
                print('wtf is this HP?')
                print(hp)
                hap_other.write(read)        
        except KeyError as e:
#            print('no HP') 
            hap_none.write(read) 

    bamfile.close()
    hap_1.close()
    hap_2.close()
    hap_other.close()
    hap_none.close()
    
  #  out_mat.close()
  #  out_pat.close()

    return 'love'

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='compare variants in a gold_std vcf and one made by nanopolish')
  #  parser.add_argument('-h',type=str,dest='hairs',required=True,help="annotated hairs file from ase script")  
    parser.add_argument('-b',type=str,dest='bam',required=True,help="BAM alignment file with Haplo TAGs")
    parser.add_argument('-o',type=str,dest='out',required=True,help="where we saving all the files")
    parser.add_argument('-n',type=str,dest='name',required=True,help="how output files are named")
#    parser.add_argument('-d',type=str,dest='datdir',required=True,help="Data directory.. methFreq is in directory.. output file goes here too")
#    parser.add_argument('-o',type=str,dest='exp',required=True,help="how the outputfile will be named")
    args = parser.parse_args()
    make_temp_sams(args.bam, args.out)  #, args.out_dir) 
#    print(len(mat))

