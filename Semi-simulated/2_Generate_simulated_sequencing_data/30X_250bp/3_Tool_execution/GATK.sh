#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --mem 32GB
#SBATCH -C stable
#SBATCH --job-name GATK.250

/gatk-4.0.1.2/gatk HaplotypeCaller -R chr1.fa -I RG.2x250.BWA-M.SORTED.SAM.bam -O GATK_R.vcf  

