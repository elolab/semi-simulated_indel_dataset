#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition long 
#SBATCH --job-name 1_5_5
#SBATCH --error 1_5_5.Errors.txt
#SBATCH --output 1_5_5.BWA-M.Console.txt

/bwa-0.7.15/bwa mem -M -t 24 reference_chr1_chr2.fa 100bp_5X_500_Venter_read1.fq 100bp_5X_500_Venter_read2.fq > 100bp_5X_500.BWA-M.SAM

/samtools-1.5/samtools view -@ 24 -bS 100bp_5X_500.BWA-M.SAM > 100bp_5X_500.BWA-M.SAM.bam

java -jar /Picard.Tools/Install.Dir/picard.jar AddOrReplaceReadGroups I=100bp_5X_500.BWA-M.SAM.bam O=RG.100bp_5X_500.BWA-M.SAM.bam RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20
/samtools-1.5/samtools sort -@ 24 RG.100bp_5X_500.BWA-M.SAM.bam > RG.100bp_5X_500.BWA-M.SORTED.SAM.bam

/samtools-1.5/samtools index -@ 24 RG.100bp_5X_500.BWA-M.SORTED.SAM.bam

