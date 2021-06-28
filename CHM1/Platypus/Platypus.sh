#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition long 
#SBATCH --job-name Platypus.A
#SBATCH --error PlatypusW.A.Errors.txt
#SBATCH --output PlatypusW.A.Console.txt

/Platypus/bin/Platypus.py callVariants --bamFiles=CHM1.SAM.SORTED.BAM --refFile=genome.fa --output=variants_W.assembel.vcf --assemble=1 --genSNPs=0 --maxSize=20000 --nCPU=24

