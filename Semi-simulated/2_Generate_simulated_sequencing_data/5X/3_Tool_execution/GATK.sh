#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition normal
#SBATCH --mem 32GB
#SBATCH -C stable
#SBATCH --job-name GATK.5
#SBATCH --error GATK.5.Errors.txt
#SBATCH --output GATK.5.Console.txt

/gatk-4.0.1.2/gatk HaplotypeCaller -R reference_chr1_chr2.fa -I RG.100bp_5X_500.BWA-M.SORTED.SAM.bam -O GATK_R.vcf  

