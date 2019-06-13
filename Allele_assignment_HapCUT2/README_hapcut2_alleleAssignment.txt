
For allele-assigment using HapCUT2, you need a PHASED vcf with heterozygos variants
   [[ note:  this assumes vcf is formatted with one with only one header line only -- sry ]] 


(1) Run the extractHairs.sh script to generate a fragment file 
 [ intakes BAM and vcf makes a 'hairs' file   ] 


(2)  Run the annotate_frag.py script, which makes a new annotated fragment file, with each read annoatated with parental-origin allele
  [ intakes 'hairs' and vcf   makes 'hairsPLUS'  ]

(3) use the pull_allele-specific_reads.py script, which  makes sam with 
    paternal and maternal reads
  [ intakes 'hairsPLUS' and BAM  output  *mat/pat_tmp.sam files  ] 

(4) the pulled_reads_to_bam.sh script then converts those sam files into bams and indexes them
 [ intakes *pat/mat_tmp sam files and makes *mat/pat BAM files ]
 
 
