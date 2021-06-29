#!/bin/sh
#SBATCH --cpus-per-task 1
#SBATCH --partition normal 
#SBATCH --job-name VarScan.5
#SBATCH --error VarScan.5.Errors.txt
#SBATCH --output VarScan.5.Console.txt

/samtools-1.5/samtools mpileup -B -f chr1.fa RG.5X.BWA-M.SORTED.SAM.bam > VarScan.short.variants.MPileup

java -jar VarScan.v2.4.3.jar mpileup2indel VarScan.short.variants.MPileup ----min-coverage 2 --output-vcf 1 --variants 1 > varscan_indel.vcf
