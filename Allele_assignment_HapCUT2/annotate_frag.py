#!/usr/bin/env python

def block_specificity(block_offset, block_alleles, variant_file):
    """
    This Function assigns specificity to each block.
    for more information about the extractHAIR command output:
    https://github.com/vibansal/HapCUT2/blob/master/old/FAQ.md
    """
    spec = ''
    genes = []
    num_variants = len(block_alleles)

    for i in range(num_variants):

        line = variant_file[int(block_offset) + i].split('\t')
        genotype = line[9].split('|')
        if block_alleles[i] == genotype[0]:
            spec += 'P'
        elif block_alleles[i] == genotype[1]:
            spec += 'M'
        chrom = line[0]
        # genes.append(line[4].split(','))

    return chrom, spec


def uniq(seq):
    """
    Output uniq values of a list
    """
    Set = set(seq)
    return list(Set)


def read_specificity(fragment_line, variant_file):
    """
    Finally assigning specificity to each read
    """
    genes_frag = []
    spec_frag = ''

    fragment = fragment_line.split(' ')
    num_blocks = int(fragment[0])
    for i in range(num_blocks):
        block_offset = fragment[5 + (2 * i)]
        block_alleles = fragment[6 + (2 * i)]
        chrom, spec = block_specificity(block_offset, block_alleles, variant_file)
          # genes_frag.append([y for x in genes for y in x])
        spec_frag += spec

    # genes_frag = uniq([y for x in genes_frag for y in x])

    return chrom, spec_frag


if __name__ == '__main__':



    with open('Na12878het.noheader.vcf') as g:
        variant_file = g.read().splitlines()




    fg = open('frag_file_from_extract_hairs', 'r') 
    outF = open("annotated_frag_file", 'w' )

    print('chrom' + "\t" + 'read_id' + "\t" + "gene_annotations" + "\t" + "num_snps" + "\t" + "p_ratio" + "\t"
          + "m_ratio" + "\t" + "allele_calling", end="\n", file=outF)
    for fragment_line in fg:

        read_id = fragment_line.split(" ")[1]
        chrom, spec = read_specificity(fragment_line, variant_file)
        p_ratio = spec.count('P') / float(len(spec))
        m_ratio = spec.count('M') / float(len(spec))
        num_snps = len(spec)

        if p_ratio >= 0.75:
            allele_calling = 'P'
        elif m_ratio >= 0.75:
            allele_calling = 'M'
        else:
            allele_calling = '.'

        new_fragment_line = chrom + "\t" + read_id + "\t" + str(num_snps)\
                            + "\t" + str(p_ratio) + "\t" + str(m_ratio) + "\t" + allele_calling
        print(new_fragment_line, end="\n", file=outF)

    outF.close()
    fg.close()

