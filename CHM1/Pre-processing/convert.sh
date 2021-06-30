#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition long 
#SBATCH --job-name Alignment
#SBATCH --error alignment.Errors.txt
#SBATCH --output alignment.Console.tMt

/samtools-1.5/samtools view -@ 24 -bS CHM1.SAM > CHM1.SAM.BAM

