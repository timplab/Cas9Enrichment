#!/usr/bin/env python 

import re
import os
import argparse

# this function takes in a vcf file
 # and retruns a list where each element is  (chr pos ref alt) 
def load_for(for_vcf):
    for_variants=[]
    f=open(for_vcf , 'r')
    for line in f:
        if line.startswith('#'):
            pass
        else:
            tings=line.split('\t')
            variant=str(tings[0]+'\t'+tings[1]+'\t'+tings[3]+'\t'+tings[4]) 
            for_variants.append(variant)
    f.close
    return for_variants

#( given a vcf file and (chr pos), returns the whole line from the vcf
def get_full_line(col2):

     f=open(args.onTarg, 'r')
     for line in f:
         if line.startswith(col2):
             goldline=line.rstrip()
     f.close
     return goldline

#parses through the reverse vcf, with a list of the 'variants' from the fwd vcf
  # if variant is common to (1) fwd (2) rev and (3) onTarg:  adds the variant FROM THE VCF USING BOTH STRANDS to out_vcf (  common variants ) 
 # also returns a list of the 'common variants' 
def make_header(onT_vcf):
    f=open(onT_vcf , 'r')
    fout=open(args.outfile, 'w')
    for line in f:
        #write the vcf header 
        if line.startswith('#'):
            fout.write(line)
    f.close
    fout.close
    return 

def get_overlaps(fwd_ls, rev_ls, onT_ls):
    fout=open(args.outfile, 'a')

    common_calls = []
    for i in fwd_ls:
        if i in rev_ls:
            if i in onT_ls:
                common_calls.append(i) 
                tings=i.split('\t')
                colz=str(tings[0]+'\t'+tings[1])
                onT_line=get_full_line(colz)
                fout.write(onT_line + '\n')
    fout.close()
    return (common_calls)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='compare variants in a gold_std vcf and one made by nanopolish')
    parser.add_argument('-f',type=str,dest='fwd',required=True,help="nanopolish fwd strand vcf")
    parser.add_argument('-r',type=str,dest='rev',required=True,help="nanopolish rev strand vcf")
    parser.add_argument('-t',type=str,dest='onTarg',required=True,help="nanopolish vcf from using both strands .. aka  onTarg")
    parser.add_argument('-o',type=str,dest='outfile',required=True,help="path to new outfile to be saved ")

    args = parser.parse_args()

    fwd_var=load_for(args.fwd)
    rev_var=load_for(args.rev)
    onT_var=load_for(args.onTarg)
    make_header(args.onTarg)        
    common_list=get_overlaps(fwd_var, rev_var, onT_var)

