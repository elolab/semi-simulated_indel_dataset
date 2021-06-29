#!/bin/sh
#SBATCH --cpus-per-task 1
#SBATCH --partition normal
#SBATCH --job-name GATK.5
#SBATCH --error GATK.5.Errors.txt
#SBATCH --output GATK.5.Console.txt

/gatk-4.0.1.2/gatk HaplotypeCaller -R chr1.fa -I RG.5X.BWA-M.SORTED.SAM.bam -O GATK_R.vcf  

