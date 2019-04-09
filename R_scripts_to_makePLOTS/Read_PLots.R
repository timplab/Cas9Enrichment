# this script takes in an input bam alignment file  
# and a bed file containing a region of interest
# output is a saved pdf file with strand-separated plots of reads in that region


library(GenomicRanges)
library(GenomicAlignments)
library(tidyverse)

getwd()
list.files()
list.files('BAMs')

##These are the regions:
    data="input_bam_file.bam" 
    target.bed="region_to_plot.bed"
    #how file name is saved:
    nombre='how_to_save'
    
##########################    
    reads=readGAlignments(data, use.names=T)
    target=read_tsv(target.bed,col_names=c("chr","start","stop")) 

    target.gr=GRanges(target)
    reads.gr=GRanges(reads)

#subsetting reads to pos + neg stranded data overlapping the target   
    pos.reads <-  subset(reads, strand == '+' )
    neg.reads <-  subset(reads, strand == '-' )
    pos.reads.gr=GRanges(pos.reads)
    neg.reads.gr=GRanges(neg.reads)

    pos.targ=overlapsAny(pos.reads.gr, target.gr)
    neg.targ=overlapsAny(neg.reads.gr, target.gr)
    ontarg.pos=pos.reads[pos.targ]
    ontarg.neg=neg.reads[neg.targ] 

# make read data into tibbles 
    ontarg.tb.pos = tibble(start=start(ontarg.pos),end=end(ontarg.pos))
    # generate the y values for rectangular plot
    ontarg.tb.pos=mutate(ontarg.tb.pos,   y1=seq(length(ontarg.pos)), y0=y1-1)

#same for neg strand    
    ontarg.tb.neg = tibble(start=start(ontarg.neg),end=end(ontarg.neg))
    ontarg.tb.neg=mutate(ontarg.tb.neg,   y1=seq(length(ontarg.neg)), y0=y1-1)   
    #invert values for neg strand 
    ontarg.tb.neg=mutate(ontarg.tb.neg,   y1=-(y1), y0=-(y0)) 

#make plot object for rectangular read plot    
    g.rect=ggplot(data=ontarg.tb.pos,mapping=aes(xmin=start,xmax=end,ymin=y0,ymax=y1))+
      geom_rect(color='red', fill='red')+ theme_bw()+
      geom_rect(data=ontarg.tb.neg, color='blue', fill='blue')+
      labs(x="Coordinate",y="Read")+xlim(target$start,target$stop)+theme_classic()


    pdf(paste0(nombre, ".target_plot.pdf"), useDingbats=FALSE)
    print(g.rect) 
    dev.off()
