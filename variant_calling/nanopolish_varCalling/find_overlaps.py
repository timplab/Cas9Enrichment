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
def get_full_line(in_vcf, col2 ):
     f=open(in_vcf, 'r')
     for line in f:
         if line.startswith(col2):
             goldline=line.rstrip()
     f.close
     return goldline

#parses through the reverse vcf, with a list of the 'variants' from the fwd vcf
  # if variant is common to both, adds the variant FROM THE VCF USING BOTH STRANDS to out_vcf (  common variants ) 
 # also returns a list of the 'common variants' 
def get_overlaps(rev_vcf, for_list, out_vcf):
    combined_calls = []
    f=open(rev_vcf , 'r')
    fout=open(out_vcf, 'w')
    for line in f:
        #first write the vcf header 
        if line.startswith('#'):
            fout.write(line)
        
        #check for overlap
        else:
            tings=line.split('\t')
#            if float(tings[5])  >=  float(100):
            variant=str(tings[0]+'\t'+tings[1]+'\t'+tings[3]+'\t'+tings[4])
            if variant in for_list:
                print(variant)
                onT_line=get_full_line(args.onTarg, tings[0]+'\t'+tings[1])
             
                #write variant line from vcf to out_file
                fout.write(onT_line + '\n' ) 
                combined_calls.append(variant)
    f.close
    fout.close
    return(combined_calls)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='compare variants in a gold_std vcf and one made by nanopolish')
    parser.add_argument('-f',type=str,dest='fwd',required=True,help="nanopolish fwd strand vcf")
    parser.add_argument('-r',type=str,dest='rev',required=True,help="nanopolish rev strand vcf")
    parser.add_argument('-t',type=str,dest='onTarg',required=True,help="nanopolish vcf from using both strands .. aka  onTarg")
    parser.add_argument('-o',type=str,dest='outfile',required=True,help="path to new outfile to be saved ")

    args = parser.parse_args()
#    print (args)

    for_var=load_for(args.fwd)
    combined=get_overlaps(args.rev, for_var, args.outfile)

#   print('VARIANTS COMMON to BOTH STRANDS')
#    for i in combined:
#        print(i)  
#    print('\n')
#    print('NUMBER OF COMMON VARIANTS')
#    print (len(combined))

