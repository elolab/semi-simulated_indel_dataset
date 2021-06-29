#!/bin/sh
#SBATCH --cpus-per-task 1
#SBATCH --partition normal 
#SBATCH --job-name Delly.30
#SBATCH --error Delly.30.Errors.txt
#SBATCH --output Delly.30.Console.txt

/delly/src/delly call -g chr1.fa RG.30X.BWA-M.SORTED.SAM.bam -i -o delly_default.bcf

/delly/bcftools/bcftools view delly_default.bcf > delly_default.vcf
