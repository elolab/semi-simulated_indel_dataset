#!/bin/sh
#SBATCH --cpus-per-task 1
#SBATCH --error TD.Error.txt
#SBATCH --output TD.Output.txt
#SBATCH --partition normal
#SBATCH --time 12:00:00
#SBATCH --job-name P_TD_R

module add R
Rscript Pindel_TD.R
