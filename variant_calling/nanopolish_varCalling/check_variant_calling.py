#!/usr/bin/env python 


# o hhiiiiii babbyyyyyyyy
# this script uses the argument parser of python to take in two inputs: 
#    >  out vcf from some script u did ( -n ) 
#    >   gold standard vcf for comparison  ( -g ) 
# prints to stdout some comparative stufff

import re
import os
import argparse

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

def get_full_line(true_vcf, col2 ):
     f=open(true_vcf, 'r')
     for line in f:
         if line.startswith(col2):
             goldline=line.rstrip()
     f.close
     return goldline

def get_real(nano_vcf, true_list):
    good_calls = []
    f=open(nano_vcf , 'r')
    for line in f:
        if line.startswith('#'):
            pass
        else:
            tings=line.split('\t')
            variant=str(tings[0]+'\t'+tings[1]+'\t'+tings[3]+'\t'+tings[4])
            if variant in true_list:
                gold_line=get_full_line(args.gold,  tings[0]+'\t'+tings[1] )
                good_calls.append(gold_line)    
    f.close
    return good_calls

def get_fake(nano_vcf, true_list):
    bad_calls = []
    f=open(nano_vcf , 'r')
    for line in f:
        if line.startswith('#'):
            pass
        else:
            tings=line.split('\t')
            variant=str(tings[0]+'\t'+tings[1]+'\t'+tings[3]+'\t'+tings[4])
            if variant not in true_list:
                bad_calls.append(variant)
    f.close
    return bad_calls


def get_missed(nano_vcf, true_list):
    missed_calls = []
    f=open(nano_vcf , 'r')
    variants_from_nano = []
    for line in f:
        if line.startswith('#'):
            pass
        else:
            tings=line.split('\t')
            variant=str(tings[0]+'\t'+tings[1]+'\t'+tings[3]+'\t'+tings[4])
            variants_from_nano.append(variant)
    for i in true_list:
        if i not in variants_from_nano:
            true_stuff=i.split('\t')
       #     print(true_stuff[0]+'\t'+true_stuff[1])
            gold_line=get_full_line(args.gold,  true_stuff[0]+'\t'+true_stuff[1] )
            missed_calls.append(gold_line)
          #  missed_calls.append(i)
    f.close
    return missed_calls

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='compare variants in a gold_std vcf and one made by nanopolish')
    parser.add_argument('-g',type=str,dest='gold',required=True,help="input gold standard vcf")
    parser.add_argument('-n',type=str,dest='np_vcf',required=True,help="nanopolish out vcf")
  #    parser.add_argument('-d',type=str,dest='datdir',required=True,help="Data directory.. methFreq is in directory.. output file goes here too")
#    parser.add_argument('-o',type=str,dest='exp',required=True,help="how the outputfile will be named")
    args = parser.parse_args()
 #    print (args)
    true_var=load_truthset(args.gold)
    correct=get_real(args.np_vcf, true_var)
    incorrect=get_fake(args.np_vcf, true_var)
    missed=get_missed(args.np_vcf, true_var)

    print('\n')
    print('CORRECTLY called variants')
    print(len(correct)) 
    print('\n')
 #   for i in correct:
 #       print(i)  
    print('\n')
    print('MISSED (but real) variants')
    print(len(missed))
    print('\n')
#    for i in missed:
#        print(i)
    print('\n')
    print('FALSE POSITIVE variants')
    print (len(incorrect))
    for i in incorrect:
        print(i)
    print('\n')

#    print(args.exp)
#    for i in incorrect:
#        print(i),

