#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --mem 32GB
#SBATCH -C stable
#SBATCH --job-name Strelka.251

/strelka2/strelka-2.9.2.centos6_x86_64/bin/configureStrelkaGermlineWorkflow.py --bam RG.2x250.BWA-M.SORTED.SAM.bam --ref chr1.fa --runDir Venter_chr1 

Venter_chr1/runWorkflow.py -m local -j 24
