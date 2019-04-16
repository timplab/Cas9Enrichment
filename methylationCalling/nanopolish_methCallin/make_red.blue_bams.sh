#!/bin/bash -l 

# shell script written by timbo_jangles (tgilpat1  <a\  jhmi.edu) 
# this script utilizes extensively code made by isac lee for his nanonome publication !! 
#thats why all the intermediate files get named things like 'isac format'
  

#   
#   this code takes the methcalls tsv produced by nanopolish ( NOT the frequency file that we generate for plotting )   
##################
#   INPUTS :: 
   # meth_calls.tsv  
   # bam (preferably phased)  

   # bed file with region(s) of interest 
###################

#this is the main directory where the data analysis is
#assumes multiple samples.. each of which are subdirectorites
maindir=path/to/data

#point to bed for regions to query
ROI=path/to/bed_file.bed
#or hardcode
#ROI='chr5:1-2000000'


#these names in this array should be the subfolders of the main directory above.. 
 # each representing the data for a different sample 
declare -a arr=( 'mcf10a' 'mdamb231'  'mcf7'  'gm12878'  )

echo 'never forget:  you are cosmic being made of light, and though it may be hard to see at times, 
    you have value to those around you. treat them well. treat them kindly. be patient. be forgiving. 
      project love' 

if true; then 
   for samp in ${arr[@]}

   do
     echo $samp

     methcalls=$maindir/$samp/*_methcalls.tsv
     thresh=2.5
     echo 'extracting meth data into bed file'
     echo 'threshold set to:'
     echo $thresh
     ./nanopolish/mtsv2bedGraph.py -i $methcalls -c $thresh  > $maindir/$samp/${samp}_isacFORMATmcalls.bed

      #this is the bed intermediate file.. not the ROI bed 
     inbed=$maindir/$samp/*_isacFORMATmcalls.bed
     echo 'sorting, bgzipping, and tab indexing le bed'
     bedtools sort -i $inbed > $maindir/$samp/${samp}_sorted_isacFormatMethCalls.bed
     bgzip $maindir/$samp/${samp}_sorted_isacFormatMethCalls.bed
     tabix -p bed $maindir/$samp/${samp}_sorted_isacFormatMethCalls.bed.gz

   done
fi

if true; then
   for samp in ${arr[@]}
   do
     echo 'combining info into blue/red bam'
     echo $samp
     isacbed=$maindir/$samp/*_sorted_isacFormatMethCalls.bed.gz
     echo $isacbed
     inbam=$maindir/$samp/*phase.bam
     outfile=$maindir/$samp/${samp}_isacHACK_hg38.bam
     ./nanopolish/convertBam.py  -b $inbam -c $isacbed -r $ROI -o $outfile
     samtools index $outfile
   done
fi



