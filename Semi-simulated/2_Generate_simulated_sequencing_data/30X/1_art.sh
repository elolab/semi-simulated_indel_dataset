#!/bin/sh
#SBATCH --cpus-per-task 1
#SBATCH --error art.Error.txt
#SBATCH --output art.Output.txt
#SBATCH --partition normal
#SBATCH --job-name art30

/art_bin_MountRainier/art_illumina -ss HS20 -i Haplotype_1_no_gap.fa -f 15 -l 100 -m 500 -s 50 -p -o Hap1_read
/art_bin_MountRainier/art_illumina -ss HS20 -i Haplotype_2_no_gap.fa -f 15 -l 100 -m 500 -s 50 -p -o Hap2_read  

cat Hap1_read1.fq Hap2_read1.fq > 30X_Venter_read1.fq
cat Hap1_read2.fq Hap2_read2.fq > 30X_Venter_read2.fq

