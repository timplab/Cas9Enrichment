#!/usr/bin/env python 

import re
import os
import argparse

#takes in vcf file and returns list of variants( chr pos ref alt ) 
def load_truthset(gold_vcf):
    real_variants=[]
    f=open(gold_vcf , 'r')
    for line in f:
        if line.startswith('#'):
            pass
        else:
            tings=line.split('\t')
            variant=str(tings[0]+'\t'+tings[1]+'\t'+tings[3]+'\t'+tings[4]) 
            real_variants.append(variant)
    f.close
    return real_variants


# takes in vcf and (chr pos) and returns the whole line of that variant from the vcf
def get_full_line(true_vcf, col2 ):
     f=open(true_vcf, 'r')
     for line in f:
         if line.startswith(col2):
             goldline=line.rstrip()
     f.close
     return goldline

#this parses throgh the 'unfiltered' variant output file 
  # it first checks that the variant has a qual score of at least the given threshold (qual_cut)
  # it only adds the variant to the output file if it is NOT in the high-confidence variant list (common to both strands) 
def qual_filt(unfilt, hi_conf):

    qual_cut=100
    outf=open('MDAMB231_low_conf_variants.txt', 'w')


    variants_passing_qual_filt = [] 
    not_in_common = 0
    for i in unfilt:     
        tings2=i.split('\t')         
        # alrite .. i  know i just got the varint from the file
          # but now we going back to the file to get the whole line 
        var_lin= get_full_line(args.unfilt,  tings2[0]+'\t'+tings2[1] )
        qual=var_lin.split('\t')[5]
   
    # first we make sure its got at least qual cutoff 
        if float(qual) >  qual_cut:
            
            #add those passing qual_cutoff to list 
            variants_passing_qual_filt.append(i) 
            # save the variants NOT in the dual-strand-filter list to new file 
            if i not in hi_conf:
                not_in_common += 1 
                outf.write(var_lin + '\n' )
    print('this many variants called that are NOT in the common')
    print(not_in_common)
    
    
    outf.close()
    return variants_passing_qual_filt

##  ifff we have a gold-standard list of variants 
  # we can tally the true positives ,  false positives, and variants missed by the dual-strand filt 
def check_perf( min_qual, gold_list, missed_list  ):

    tp_tally= []
    fp_tally = []
    mist_tally = []

    for i in min_qual:
        if i in gold_list:
            tp_tally.append(i)   
        if i not in gold_list:
            fp_tally.append(i) 
        if i in missed_list:
            mist_tally.append(i)

    print('thismany TPs') 
    print(len(tp_tally))
    print('thismany FPs')
    print(len(fp_tally))
    print('thismany lostboyz')
    print(len(mist_tally))

    return 


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Compare variants in a gold_std vcf and one made by nanopolish')
#    parser.add_argument('-m',type=str,dest='missed',required=True,help="Missed variants by the common to strand filter")
    parser.add_argument('-c',type=str,dest='comm',required=True,help="high confidence variants-- passing dual-strand filteR")
    parser.add_argument('-u',type=str,dest='unfilt',required=True,help="unfiltered variants -- the 'onTarg' vcf from min freq 25 ")
#    parser.add_argument('-o',type=str,dest='exp',required=True,help="how the outputfile will be named")
    args = parser.parse_args()

 # loading the 'common' (hiQ) variants  and the  unfitlered variants into lists
    common=load_truthset(args.comm)
    unfilt=load_truthset(args.unfilt) 
   # get a list of variants passing qual filter.  .. save those not in high qual (common) variants to a new file     
    min_qual = qual_filt(unfilt, common)


#########################
#########################
  ##  ifff we have a gold-standard list of variants 
  # we can tally the true positives ,  false positives, and variants missed by the dual-strand filt 
  # otherwise DONT run the 3 lines of this block 
  #load platinum genome SNP variants into a list
    
#    gold=load_truthset('/data/8_sites/pg17_8_sites_SNPSONLY.vcf')
#    mist=load_truthset('missed_15perc.txt')    
#    check_perf( min_qual, gold, mist ) 

###############################
