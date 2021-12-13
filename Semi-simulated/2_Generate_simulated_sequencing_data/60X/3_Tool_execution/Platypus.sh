#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition normal 
#SBATCH --mem 32GB
#SBATCH -C stable
#SBATCH --job-name Platypus.60.A
#SBATCH --error Platypus.60.A.Errors.txt
#SBATCH --output Platypus.60.A.Console.txt

export LD_LIBRARY_PATH
LD_LIBRARY_PATH=/htslib

python /Platypus/bin/Platypus.py callVariants --bamFiles=RG.100bp_60X_500.BWA-M.SORTED.SAM.bam --refFile=reference_chr1_chr2.fa --output=variants.assembel.vcf --assemble=1 --genSNPs=0 --maxSize=8000 --nCPU=24

