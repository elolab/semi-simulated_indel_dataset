#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition normal 
#SBATCH --job-name Platypus.60
#SBATCH --error Platypus.60.Errors.txt
#SBATCH --output Platypus.60.Console.txt

python /Platypus/bin/Platypus.py callVariants --bamFiles=RG.60X.BWA-M.SORTED.SAM.bam --refFile=chr1.fa --output=variants.vcf --genSNPs=0 --maxSize=6100 --nCPU=24

