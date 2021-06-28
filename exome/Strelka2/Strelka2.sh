#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition normal 
#SBATCH --job-name Strelka.100HG
#SBATCH --error Strelka.5.Errors.txt
#SBATCH --output Strelka.5.Console.txt

/strelka2/strelka-2.9.2.centos6_x86_64/bin/configureStrelkaGermlineWorkflow.py --bam 151002_7001448_0359_AC7F6GANXX_Sample_HG002-EEogPU_v02-KIT-Av5_AGATGTAC_L008.posiSrt.markDup.bam  --ref hs37d5.fa.gz --exome --callRegions exome-target-region.bed.gz --runDir hg 

hg/runWorkflow.py -m local -j 24
