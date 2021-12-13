#!/bin/sh
#SBATCH --cpus-per-task 12
#SBATCH --error art.Error.txt
#SBATCH --output art.Output.txt
#SBATCH --partition normal
#SBATCH --time 12:00:00
#SBATCH --job-name 5_15_30

/art_bin_MountRainier/art_illumina -ss MSv1 -na -i Haplotype_1_no_gap.fa -f 15 -l 250 -m 500 -s 50 -p -rs 1234 -o Hap1_read
/art_bin_MountRainier/art_illumina -ss MSv1 -na -i Haplotype_2_no_gap.fa -f 15 -l 250 -m 500 -s 50 -p -rs 1234 -o Hap2_read  

cat Hap1_read1.fq Hap2_read1.fq > 250bp_30X_500_Venter_read1.fq
cat Hap1_read2.fq Hap2_read2.fq > 250bp_30X_500_Venter_read2.fq

module add fastqc
fastqc --threads 12 250bp_30X_500_Venter_read1.fq
fastqc --threads 12 250bp_30X_500_Venter_read2.fq

cat 250bp_30X_500_Venter_read1.fq 250bp_30X_500_Venter_read2.fq > fermikit.fq


