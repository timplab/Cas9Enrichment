#!/usr/env Rscript

# this script takes in the CpG report file made by the bismark methylation aligner
 # and the methylation frequnecy file produced by the nanopolish supplementary script calculate_methylation_frequency.py 

#this produces a line plots comparing methylation at the regions (hard-coded)
 # as wel as heatmaps and dotplots comparing per-CpG methylation 

# this script was written by Isac Lee -- which is why its so much 
  # better looking than all the other scripts in here which were written by that clown gilfunk 


library(bsseq)
library(tidyverse)
library(GenomicRanges)
#library(wesanderson)
source("/home/isac/Code/ilee/plot/ggplot_theme.R")

bismarkpath = "/kyber/Data/Nanopore/Analysis/gilfunk/breastPanel/gm12878_bismark/gm12878_bismark_methylation_out/gm12878_bismark_namesort.CpG_report.txt.gz"
minpath = "/kyber/Data/Nanopore/Analysis/gilfunk/191005_hack_gm12878.multi/min/methcals/min_mFREQ.tsv"
outdir = "."

## read in data from bismark methylation calls 
bismark = read.bismark(bismarkpath,strandCollapse=T,rmZeroCov=T)
bismark.mcov = as.tibble(getCoverage(bismark,type="M",what="perBase")) %>%
    rename(methylated = starts_with('/'))
bismark.cov = as.tibble(getCoverage(bismark,type="Cov",what="perBase")) %>%
    rename(coverage = starts_with('/'))
bismark.reg = as.tibble(granges(bismark))
bismark.tb = bind_cols(bismark.reg,bismark.cov,bismark.mcov) %>%
    mutate(frequency = methylated/coverage,
           sample = "bismark",
           chromosome = as.character(seqnames)) %>%
    select(chromosome,start,end,coverage,frequency,sample) %>%
    na.omit()

## read in nanopore methylation calls (from frequency file ) 
min.tb = read_tsv(minpath) %>%
    rename(frequency = methylated_frequency,
           coverage = called_sites ) %>%
    mutate(sample = "minion",
           start = start+1) %>%
    select(chromosome,start,end,coverage,frequency,sample)

dat.tb = do.call(rbind,list(bismark.tb,min.tb)) %>%
    filter(coverage > 5)
dat.gr = GRanges(dat.tb)

## regions
#   updated  oct 21 2019  with guides for multi-guides around 5 methylation regions 
regs = GRanges(seqnames = c("chr3","chr9","chr11","chr16","chr17"),
               ranges = IRanges(start=c(49352623,35677525,67577032,67952369,41517522),
                               end=c(49366169,35697166,67594247,67976758,41535711 )) )

ovl = findOverlaps(dat.gr,regs)
dat.ovl = dat.tb[queryHits(ovl),] %>%
    mutate(reg = subjectHits(ovl))

## create onject with spread of data 
dat.spread = dat.ovl %>%
    dplyr::select(chromosome,start,frequency,sample,reg) %>%
    spread(sample,frequency) %>%
    na.omit()


## get correlation
print('==============')
print('this is the aggregate correlation btwn bismark calls and nanopore calls over all regions specified') 
cor(dat.spread$bismark,dat.spread$minion)
print('==============')

## plot
g = ggplot(dat.spread,aes(x=bismark,y=minion)) +
    theme_bw()
g.scatter = g + facet_wrap(.~reg) +
    geom_point() +  coord_fixed()

plotpath = file.path(outdir,"200108_scatterDim2.pdf")
pdf(plotpath,useDingbats=F)
print(g.scatter)
dev.off()
