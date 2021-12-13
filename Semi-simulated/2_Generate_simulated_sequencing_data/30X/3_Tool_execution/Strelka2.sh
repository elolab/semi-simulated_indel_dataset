#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition normal 
#SBATCH --mem 32GB
#SBATCH -C stable
#SBATCH --job-name Strelka.30
#SBATCH --error Strelka.30.Errors.txt
#SBATCH --output Strelka.30.Console.txt

/strelka2/strelka-2.9.2.centos6_x86_64/bin/configureStrelkaGermlineWorkflow.py --bam RG.100bp_30X_500.BWA-M.SORTED.SAM.bam --ref reference_chr1_chr2.fa --runDir Venter_chr1_chr2 

Venter_chr1_chr2/runWorkflow.py -m local -j 24
