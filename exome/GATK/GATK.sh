#!/bin/sh
#SBATCH --cpus-per-task 12
#SBATCH -t 6:00:00
#SBATCH --job-name GATK

/wrk/sofia/local/Ning/software/software2/gatk-4.0.1.2/gatk  HaplotypeCaller -R hs37d5_ungzipped.fa -I 151002_7001448_0359_AC7F6GANXX_Sample_HG002-EEogPU_v02-KIT-Av5_AGATGTAC_L008.posiSrt.markDup.bam -L wex_Agilent_SureSelect_v05_b37.baits.slop50.merged.bed  -O GATK.vcf 

