#!/bin/sh
#SBATCH --cpus-per-task 36
#SBATCH --error Trimming.Error.txt
#SBATCH --output Trimming.Output.txt
#SBATCH --partition long
#SBATCH --time 08-08
#SBATCH --job-name Trimming

module add cutadapt/1.9.dev6
module add fastqc/0.11.3
module add trimgalore/0.4.2
trim_galore --quality 20 --output_dir ./trimmed --stringency 1 --length 20 --fastqc --paired CHM1_1.fastq.bz2 CHM1_2.fastq.bz2 
