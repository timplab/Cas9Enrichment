#!/bin/bash

inbam=input_bam_file
out_dir=where_temp_sams_are

name=how_to_name_output_files

echo $inbam
samtools view -H $inbam  > $out_dir/header_tmp.sam

cat $out_dir/header_tmp.sam  $out_dir/maternal*.sam >  $out_dir/maternal_with_header.sam
cat $out_dir/header_tmp.sam  $out_dir/paternal*.sam >  $out_dir/paternal_with_header.sam

samtools view $out_dir/maternal_with_header.sam -h -o  $out_dir/${name}_mat.bam
samtools view $out_dir/paternal_with_header.sam -h -o  $out_dir/${name}_pat.bam

samtools index $out_dir/${name}_mat.bam
samtools index $out_dir/${name}_pat.bam

rm $out_dir/*.sam

