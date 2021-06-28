#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition normal 
#SBATCH --job-name Platypus.hg100
#SBATCH --error Platypus.5.Errors.txt
#SBATCH --output Platypus.5.Console.txt

python /Platypus/bin/Platypus.py callVariants --bamFiles=151002_7001448_0359_AC7F6GANXX_Sample_HG002-EEogPU_v02-KIT-Av5_AGATGTAC_L008.posiSrt.markDup.bam --refFile=hs37d5.fa --output=variants.vcf --genSNPs=0 --nCPU=24

