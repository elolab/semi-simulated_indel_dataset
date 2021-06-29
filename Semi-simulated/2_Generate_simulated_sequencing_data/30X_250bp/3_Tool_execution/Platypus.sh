#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --mem 32GB
#SBATCH -C stable
#SBATCH --job-name Platypus.251.A

python /Platypus/bin/Platypus.py callVariants --bamFiles=RG.2x250.BWA-M.SORTED.SAM.bam --refFile=chr1.fa --output=variants.assembel_running.vcf --assemble=1 --genSNPs=0 --maxSize=6100 --nCPU=24

