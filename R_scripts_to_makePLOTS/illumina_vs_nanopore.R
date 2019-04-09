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

bismarkpath = "/kyber/Data/Nanopore/Analysis/gilfunk/breastPanel/gm12878_bismark/gm12878_bismark_methylation_out/gm12878_bismark_namesort.CpG_report.txt.gz"
nanoporepath = "/kyber/Data/Nanopore/Analysis/gilfunk/breastPanel/190209_methylation_Data/output_files/gm12878/gm12878_COMBINED_methcalls_thr2.5.mfreq.tsv"

outdir = "/kyber/Data/Nanopore/Analysis/gilfunk/breastPanel/190209_methylation_Data/plots"

## read in data
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

nanopore.tb = read_tsv(nanoporepath) %>%
    rename(frequency = methylated_frequency,
           coverage = called_sites ) %>%
    mutate(sample = "nanopore",
           start = start+1) %>%
    select(chromosome,start,end,coverage,frequency,sample)

dat.tb = do.call(rbind,list(bismark.tb,nanopore.tb)) %>%
    filter(coverage > 5)
dat.gr = GRanges(dat.tb)

## regions
regs = GRanges(seqnames = c("chr11","chr17","chr9","chr3","chr16"),
               ranges = IRanges(start = c(67576428,41517522,35677525,49352525,67952369),
                                end = c(67594247,41535711,35697166,49366169,67976758)))
ovl = findOverlaps(dat.gr,regs)

## do region plots
plotpath = file.path(outdir,"nanopore_vs_illumina_regions.pdf")
pdf(plotpath,useDingbats=F)
for (i in seq_along(regs)) {
    print(i)
    dat.reg = dat.tb[queryHits(ovl)[which(subjectHits(ovl)==i)],]
    g = ggplot(dat.reg,aes(x = start, y = frequency, color = sample, group = sample))+
        geom_point(size=0.5,alpha=0.5)+
        geom_smooth(se=F,span=0.5)+
        theme_bw()
    print(g)
}
dev.off()

## heatmap
dat.spread = dat.tb %>%
    select(chromosome,start,frequency,sample) %>%
    spread(sample,frequency) %>%
    na.omit()
## get correlation
cor(dat.spread$bismark,dat.spread$nanopore)

## plot
g = ggplot(dat.spread,aes(x = bismark,y = nanopore)) +
    theme_bw()
g.2den = g + stat_density_2d(aes(fill=stat(level)),geom="polygon")
g.heat = g + geom_bin2d() +
    scale_fill_gradient( trans = 'log' ) 
g.hex = g + geom_hex()+
    scale_fill_brewer(palette="Spectral")

plotpath = file.path(outdir,"nanopore_vs_illumina_heatmap.pdf")
pdf(plotpath,useDingbats=F)
print(g.2den)
print(g.heat)
print(g.hex)
dev.off()
