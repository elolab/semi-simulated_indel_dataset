#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition long 
#SBATCH --job-name Alignment
#SBATCH --error alignment.Errors.txt
#SBATCH --output alignment.Console.tMt

/samtools-1.5/bin/samtools sort -@ 24 CHM1.SAM.BAM > CHM1.SAM.SORTED.BAM

