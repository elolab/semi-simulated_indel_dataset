#!/bin/sh
#SBATCH --cpus-per-task 1
#SBATCH --error results.Error.txt
#SBATCH --output results.Output.txt
#SBATCH --partition normal
#SBATCH --job-name results

module add R
Rscript parse.DeepVariants.R
