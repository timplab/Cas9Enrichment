#!/usr/env Rscript

# this script takes in an input bam alignment file  
   # and a bed file with (1) region of interest for which to generate a coverage plot 
# output is a saved pdf file with coverage at that locus

#install.packages("tidyverse")
#install.packages("cowplot")

library(GenomicRanges)
library(GenomicAlignments)
library(tidyverse)
library(cowplot)

# defining target locus for plotting 
  target.bed="/home/gilfunk/script/noT_getting_uploading/old_R_scripts/even_older/krt19_5kbflank.bed"
  target=read_tsv(target.bed,col_names=c("chr","start","stop")) 
  target.gr=GRanges(target)

# where (outdir) and how (nombre)  the output plot  will be saved 
  outdir='~'
  nombre='200106-covPlotBETA'
  
## for simplicity (laziness?) I loaded data for each of the bam files one at a time, making a new tibble for each one, 
  # I then made a plot using each of those tibbles

################
    in_data="/kyber/Data/Nanopore/Analysis/gilfunk/190508_recalledDATA_gup_flip/onTarg_mm2/min_gup3_prim_onTarg.bam"
    reads=readGAlignments(in_data, use.names=T)
    reads.gr=GRanges(reads)
    on.targ=overlapsAny(reads.gr, target.gr)
    #here we only take those reads that meet that on-targ criteria
    ontarg.reads=reads[on.targ]
    #get coverage data
    cov.targ=as.vector(coverage(ontarg.reads)[[target$chr]])
    cov.targ<-cov.targ[target$start:target$stop]
    cov.plt.min= tibble(cov=cov.targ, pos=seq(start(target.gr),end(target.gr)))

################
    in_data="/kyber/Data/Nanopore/Analysis/gilfunk/190925_flg_multi_GM12878/prim_onTarg/190925_flg_multi_GM12878_prim_onTarg.bam"
    reads=readGAlignments(in_data, use.names=T)
    reads.gr=GRanges(reads)
    on.targ=overlapsAny(reads.gr, target.gr)
    #here we only take those reads that meet that on-targ criteria
    ontarg.reads=reads[on.targ]
    #get coverage data
    cov.targ=as.vector(coverage(ontarg.reads)[[target$chr]])
    cov.targ<-cov.targ[target$start:target$stop]
    cov.plt.3flg= tibble(cov=cov.targ, pos=seq(start(target.gr),end(target.gr)))

################
    in_data="/kyber/Data/Nanopore/Analysis/gilfunk/190824_allGuidez_take2_GM12878/prim_onTarg/190824_allguides_take2_gm12878_onTarg_prim.bam"
    reads=readGAlignments(in_data, use.names=T)
    reads.gr=GRanges(reads)
    on.targ=overlapsAny(reads.gr, target.gr)
    #here we only take those reads that meet that on-targ criteria
    ontarg.reads=reads[on.targ]
    #get coverage data
    cov.targ=as.vector(coverage(ontarg.reads)[[target$chr]])
    cov.targ<-cov.targ[target$start:target$stop]
    cov.plt.3min= tibble(cov=cov.targ, pos=seq(start(target.gr),end(target.gr)))

################
    in_data="/kyber/Data/Nanopore/Analysis/gilfunk/190921_mostLYfresh/190918_c3.c4_frosh/prim_onTarg/c3_prim_onTarg.bam"
    reads=readGAlignments(in_data, use.names=T)
    reads.gr=GRanges(reads)
    on.targ=overlapsAny(reads.gr, target.gr)
    #here we only take those reads that meet that on-targ criteria
    ontarg.reads=reads[on.targ]
    #get coverage data
    cov.targ=as.vector(coverage(ontarg.reads)[[target$chr]])
    cov.targ<-cov.targ[target$start:target$stop]
    cov.plt.c3= tibble(cov=cov.targ, pos=seq(start(target.gr),end(target.gr)))

 #######################
    g.cov=ggplot( )+ theme_bw()+ 
          geom_line(data=cov.plt.c3, mapping=aes(x=pos,y=cov), color='blue', size=1.5  ) +
 
 	  geom_line(data=cov.plt.3min, mapping=aes(x=pos,y=cov), color='green', size=1.5  ) +
	  geom_line(data=cov.plt.min, mapping=aes(x=pos,y=cov), color='black', size=1.5  ) +

	  geom_line(data=cov.plt.3flg, mapping=aes(x=pos,y=cov), color='orange', size=1.5  ) +
	  xlim(target$start,target$stop) 

 save_plot(  paste0( nombre, ".targeSIDE_PDF.pdf" ), g.cov, base_aspect_ratio = 2 )
 dev.off()   
