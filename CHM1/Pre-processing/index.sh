#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition long 
#SBATCH --job-name Alignment
#SBATCH --error alignment.Errors.txt
#SBATCH --output alignment.Console.tMt

/samtools-1.5/bin/samtools index -@ 24 CHM1.chr1.bam 

