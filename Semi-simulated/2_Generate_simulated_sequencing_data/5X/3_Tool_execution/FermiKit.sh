#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition normal 
#SBATCH --mem 32GB
#SBATCH -C stable
#SBATCH --job-name FermiKit.5
#SBATCH --error FermiKit.5.Errors.txt
#SBATCH --output FermiKit.5.Console.txt

/fermikit/fermi.kit/fermi2.pl unitig -t24 -s492m -l100 -p fermikit fermikit.fq  > fermikit.mak
make -f fermikit.mak
/fermikit/fermi.kit/run-calling -t24 reference_chr1_chr2.fa fermikit.mag.gz | sh
