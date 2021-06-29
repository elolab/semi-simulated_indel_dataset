#!/bin/sh
#SBATCH --cpus-per-task 1
#SBATCH --partition normal 
#SBATCH --job-name VarScan.60
#SBATCH --error VarScan.60.Errors.txt
#SBATCH --output VarScan.60.Console.txt

/samtools-1.5/samtools mpileup -B -f chr1.fa RG.60X.BWA-M.SORTED.SAM.bam > VarScan.short.variants.MPileup

java -jar VarScan.v2.4.3.jar mpileup2indel VarScan.short.variants.MPileup --output-vcf 1 --variants 1 > varscan_indel.vcf
