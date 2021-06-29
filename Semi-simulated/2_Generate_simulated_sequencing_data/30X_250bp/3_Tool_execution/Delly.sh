#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH -C stable
#SBATCH --mem 32GB
#SBATCH --job-name Delly.250

/delly/src/delly call -g RG.2x250.BWA-M.SORTED.SAM.bam -i -o delly_default.bcf

/delly/bcftools/bcftools view delly_default.bcf > delly_default.vcf
