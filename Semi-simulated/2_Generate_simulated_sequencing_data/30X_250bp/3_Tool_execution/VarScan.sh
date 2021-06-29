#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --mem 32GB 
#SBATCH -C stable
#SBATCH --job-name VarScan.251

/samtools-1.5/samtools mpileup -B -f chr1.fa RG.2x250.BWA-M.SORTED.SAM.bam > VarScan.short.variants.MPileup

java -jar VarScan.v2.4.3.jar mpileup2indel VarScan.short.variants.MPileup --output-vcf 1 --variants 1 > varscan_indel.vcf
