#!/bin/sh
#SBATCH --cpus-per-task 1
#SBATCH --error D.Error.txt
#SBATCH --output D.Output.txt
#SBATCH --partition normal
#SBATCH --time 12:00:00
#SBATCH --job-name P_D_I

module add R
Rscript Pindel_D.R
