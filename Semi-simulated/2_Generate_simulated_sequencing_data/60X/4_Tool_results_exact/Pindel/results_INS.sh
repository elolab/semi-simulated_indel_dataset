#!/bin/sh
#SBATCH --cpus-per-task 1
#SBATCH --error INS.Error.txt
#SBATCH --output INS.Output.txt
#SBATCH --partition normal
#SBATCH --time 12:00:00
#SBATCH --job-name P_I_R

module add R
Rscript Parse_Pindel_INS.R
