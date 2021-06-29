#!/bin/sh
#SBATCH --cpus-per-task 1
#SBATCH --mem 20000
#SBATCH --partition normal 
#SBATCH --job-name Delly.60
#SBATCH --error Delly.60.Errors.txt
#SBATCH --output Delly.60.Console.txt

/delly/src/delly call -g chr1.fa RG.60X.BWA-M.SORTED.SAM.bam -i -o delly_default.bcf

/delly/bcftools/bcftools view delly_default.bcf > delly_default.vcf
