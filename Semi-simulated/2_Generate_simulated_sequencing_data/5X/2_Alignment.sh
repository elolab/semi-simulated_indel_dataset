#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition normal 
#SBATCH --job-name 5X.BWA-M
#SBATCH --error 5X.BWA-M.Errors.txt
#SBATCH --output 5X.BWA-M.Console.txt

/bwa-0.7.15/bwa mem -M -t 24 chr1.fa 5X_Venter_read1.fq 5X_Venter_read2.fq > 5X.BWA-M.SAM

/samtools-1.5/samtools view -@ 24 -bS 5X.BWA-M.SAM > 5X.BWA-M.SAM.bam

java -jar /Picard.Tools/Install.Dir/picard.jar AddOrReplaceReadGroups I=5X.BWA-M.SAM.bam O=RG.5X.BWA-M.SAM.bam RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20

/samtools-1.5/bin/samtools sort -@ 24 RG.5X.BWA-M.SAM.bam > RG.5X.BWA-M.SORTED.SAM.bam

/samtools-1.5/bin/samtools index -@ 24 RG.5X.BWA-M.SORTED.SAM.bam

