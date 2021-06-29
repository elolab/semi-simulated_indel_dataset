#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --mem 32GB
#SBATCH -t 6:00:00
#SBATCH --job-name 2X250.BWA-M


/bwa-0.7.15/bwa mem -M -t 24 chr1.fa 2x250_Venter_read1.fq 2x250_Venter_read2.fq > 2x250.BWA-M.SAM

/samtools-1.5/samtools view -@ 24 -bS 2x250.BWA-M.SAM > 2x250.BWA-M.SAM.bam

java -jar /Picard.Tools/Install.Dir/picard.jar AddOrReplaceReadGroups I=2x250.BWA-M.SAM.bam O=RG.2x250.BWA-M.SAM.bam RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20

/samtools-1.5/samtools sort -@ 24 RG.2x250.BWA-M.SAM.bam > RG.2x250.BWA-M.SORTED.SAM.bam

/samtools-1.5/samtools index -@ 24 RG.2x250.BWA-M.SORTED.SAM.bam

