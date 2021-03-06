#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition normal 
#SBATCH --job-name Strelka.60
#SBATCH --error Strelka.60.Errors.txt
#SBATCH --output Strelka.60.Console.txt

/strelka2/strelka-2.9.2.centos6_x86_64/bin/configureStrelkaGermlineWorkflow.py --bam RG.60X.BWA-M.SORTED.SAM.bam --ref chr1.fa --runDir Venter_chr1 

Venter_chr1/runWorkflow.py -m local -j 24
