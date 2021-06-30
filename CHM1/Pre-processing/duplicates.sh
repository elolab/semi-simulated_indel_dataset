#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition long
#SBATCH --job-name DUP.BWA-M
#SBATCH --error DUP.BWA-M.Errors.txt
#SBATCH --output DUP.BWA-M.Console.txt

java -jar /Picard.Tools/Install.Dir/picard.jar MarkDuplicates I=CHM1.SAM.SORTED.BAM O=CHM1.SAM.SORTED.MARK.DUPLICATES.BAM M=marked_dup_metrics.txt
