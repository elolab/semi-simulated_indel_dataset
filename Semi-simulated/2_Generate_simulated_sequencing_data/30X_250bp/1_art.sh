#!/bin/sh
#SBATCH --cpus-per-task 1
#SBATCH -t 3:00:00
#SBATCH --job-name art250

/art_bin_MountRainier/art_illumina -ss MSv1 -na -i Haplotype_1_no_gap.fa -f 15 -l 250 -m 800 -s 50 -p -o Hap1_read
/art_bin_MountRainier/art_illumina -ss MSv1 -na -i Haplotype_2_no_gap.fa -f 15 -l 250 -m 800 -s 50 -p -o Hap2_read  

cat Hap1_read1.fq Hap2_read1.fq > 2x250_Venter_read1.fq
cat Hap1_read2.fq Hap2_read2.fq > 2x250_Venter_read2.fq

