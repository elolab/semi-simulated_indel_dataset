#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition long 
#SBATCH --job-name Alignment
#SBATCH --error alignment.Errors.txt
#SBATCH --output alignment.Console.tMt

/bwa-0.7.15/bwa mem -M -t 24 genome.fa CHM1_1.fastq.bz2_val_1.fq CHM1_2.fastq.bz2_val_2.fq > CHM1.SAM

