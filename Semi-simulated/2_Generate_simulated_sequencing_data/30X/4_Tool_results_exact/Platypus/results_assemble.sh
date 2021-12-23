#!/bin/sh
#SBATCH --cpus-per-task 1
#SBATCH --error Assemble.Error.txt
#SBATCH --output aSSEMBLE.Output.txt
#SBATCH --partition normal
#SBATCH --time 12:00:00
#SBATCH --job-name Platyus_R

module add R
Rscript parse_Platypus_assemble.R
