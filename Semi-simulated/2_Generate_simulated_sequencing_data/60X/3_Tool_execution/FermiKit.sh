#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition long
#SBATCH --mem 32GB
#SBATCH -C stable
#SBATCH --job-name FermiKit.60
#SBATCH --error FermiKit.60.Errors.txt
#SBATCH --output FermiKit.60.Console.txt

/fermikit/fermi.kit/fermi2.pl unitig -t24 -s492m -l100 -p fermikit fermikit.fq  > fermikit.mak
make -f fermikit.mak
/fermikit/fermi.kit/run-calling -t24 reference_chr1_chr2.fa fermikit.mag.gz | sh
