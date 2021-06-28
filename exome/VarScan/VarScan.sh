#!/bin/sh
#SBATCH --cpus-per-task 8
#SBATCH --partition normal 
#SBATCH --job-name VarScan
#SBATCH --error VarScan.txt
#SBATCH --output VarScan.txt

/samtools-1.5/samtools mpileup -B -f hs37d5.fa 151002_7001448_0359_AC7F6GANXX_Sample_HG002-EEogPU_v02-KIT-Av5_AGATGTAC_L008.posiSrt.markDup.bam > VarScan.short.variants.MPileup

java -jar VarScan.v2.4.3.jar mpileup2indel VarScan.short.variants.MPileup --output-vcf 1 --variants 1 > varscan_indel.vcf
