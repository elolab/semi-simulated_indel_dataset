#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition normal 
#SBATCH --job-name Strelka.5
#SBATCH --error Strelka.5.Errors.txt
#SBATCH --output Strelka.5.Console.txt

/strelka2/strelka-2.9.2.centos6_x86_64/bin/configureStrelkaGermlineWorkflow.py --bam RG.5X.BWA-M.SORTED.SAM.bam --ref chr1.fa --runDir Venter_chr1 

Venter_chr1/runWorkflow.py -m local -j 24
