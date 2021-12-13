#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition long 
#SBATCH --job-name 25_30_5
#SBATCH --error 25_30_5.BWA-M.Errors.txt
#SBATCH --output 25_30_5.BWA-M.Console.txt

/bwa-0.7.15/bwa mem -M -t 24 reference_chr1_chr2.fa 250bp_30X_500_Venter_read1.fq 250bp_30X_500_Venter_read2.fq > 250bp_30X_500.BWA-M.SAM

/samtools-1.5/samtools view -@ 24 -bS 250bp_30X_500.BWA-M.SAM > 250bp_30X_500.BWA-M.SAM.bam

java -jar Picard.Tools/Install.Dir/picard.jar AddOrReplaceReadGroups I=250bp_30X_500.BWA-M.SAM.bam O=RG.250bp_30X_500.BWA-M.SAM.bam RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20

/samtools-1.5/samtools sort -@ 24 RG.250bp_30X_500.BWA-M.SAM.bam > RG.250bp_30X_500.BWA-M.SORTED.SAM.bam

/samtools-1.5/samtools index -@ 24 RG.250bp_30X_500.BWA-M.SORTED.SAM.bam

