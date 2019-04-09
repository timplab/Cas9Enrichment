#!/usr/env Rscript


# this script takes in an input bam alignment file  
# and a bed file containing a region of interest
# output is a saved pdf file with coverage at that locus


#install.packages("tidyverse")
#install.packages("cowplot")

library(GenomicRanges)
library(GenomicAlignments)
library(tidyverse)
library(cowplot)

getwd()
list.files()

##These are the regions:
    in_data="input_bam_file.bam"
    target.bed="chr6_bed.bed"
    #how file name is saved:
    nombre='how_plot_file_wil_be_saved'
    
##########################    
    reads=readGAlignments(in_data, use.names=T)
    target=read_tsv(target.bed,col_names=c("chr","start","stop")) 
    target.gr=GRanges(target)
    reads.gr=GRanges(reads)
 
#subsetting reads to data overlapping the target   
    #here we get the granges of the 'on-targ' for each data set 
    on.targ=overlapsAny(reads.gr, target.gr)

    #here we only take those reads that meet that on-targ criteria
    ontarg.reads=reads[on.targ]

    #get coverage data
    cov.targ=as.vector(coverage(ontarg.reads)[[target$chr]])
    cov.targ<-cov.targ[target$start:target$stop]

    cov.plt= tibble(cov=cov.targ, pos=seq(start(target.gr),end(target.gr)))

    g.cov=ggplot( )+ theme_bw()+  geom_line(data=cov.plt.mom, mapping=aes(x=pos,y=cov), color='indianred1', size=1.5  ) +
         xlim(target$start,target$stop) 
    
    save_plot(  paste0( nombre, ".targeSIDE_PDF.pdf" ), g.cov, base_aspect_ratio = 1  )

    
