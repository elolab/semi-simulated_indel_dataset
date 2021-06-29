#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition normal 
#SBATCH --job-name Platypus.5.A
#SBATCH --error Platypus.5.A.Errors.txt
#SBATCH --output Platypus.5.A.Console.txt

python /Platypus/bin/Platypus.py callVariants --bamFiles=RG.5X.BWA-M.SORTED.SAM.bam --refFile=chr1.fa --output=variants.assembel.vcf --assemble=1 --genSNPs=0 --maxSize=6100 --nCPU=24

