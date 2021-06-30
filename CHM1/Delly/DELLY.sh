#!/bin/sh
#SBATCH --cpus-per-task 1
#SBATCH --partition long 
#SBATCH --job-name Delly

/delly/src/delly call -g genome.fa CHM1.SAM.SORTED.BAM -i -o delly_WGS.bcf

/delly/bcftools/bcftools view delly_WGS.bcf > delly_WGS.vcf
