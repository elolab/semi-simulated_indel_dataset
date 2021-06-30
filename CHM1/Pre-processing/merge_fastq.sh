#!/bin/sh
#SBATCH --cpus-per-task 32
#SBATCH --error merge.Error.txt
#SBATCH --output merge.Output.txt
#SBATCH --partition long
#SBATCH --job-name merge

cat SRR1514950_1.fastq.bz2 SRR1514951_1.fastq.bz2 SRR1514952_1.fastq.bz2 > CHM1_1.fastq.bz2
cat SRR1514950_2.fastq.bz2 SRR1514951_2.fastq.bz2 SRR1514952_2.fastq.bz2 > CHM1_2.fastq.bz2
