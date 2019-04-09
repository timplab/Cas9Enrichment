To use the variant calling script as provided (04.1cas9_VARIANTS.sh)
 you first need to make strand specific bam files from the alignment data, 
 which can be done using the 'bam_strand_filter.sh' script


(1) edit and execute the 04.1cas9_VARIANTS.sh script, which results in an 'onTarg.vcf'
  as well as a 'commonToBoth.vcf' which only has variant supported by both strands
   [ this calls the find-overlaps.py script , so keep that in the path] 

(2) low-confidence variants (as defined in the main text) can be found using the 
   script 'lowConf_variant_call_QualFilter.py' 


(3) You can compare the vcf output files against a reference vcf using the check_variant_calling.py script 


