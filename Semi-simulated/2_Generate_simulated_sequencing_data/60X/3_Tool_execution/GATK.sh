#!/bin/sh
#SBATCH --cpus-per-task 1
#SBATCH --partition normal
#SBATCH --job-name GATK.60
#SBATCH --error GATK.60.Errors.txt
#SBATCH --output GATK.60.Console.txt

/gatk-4.0.1.2/gatk HaplotypeCaller -R chr1.fa -I RG.60X.BWA-M.SORTED.SAM.bam -O GATK_R.vcf  

