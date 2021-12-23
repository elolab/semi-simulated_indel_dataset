#!/bin/sh
#SBATCH --cpus-per-task 1
#SBATCH --error results.Error.txt
#SBATCH --output results.Output.txt
#SBATCH --partition normal
#SBATCH --time 12:00:00
#SBATCH --job-name DELLY_R

module add R
Rscript parse_Delly.R
