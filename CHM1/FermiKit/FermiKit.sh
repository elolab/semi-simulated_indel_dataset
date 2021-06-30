#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition long 
#SBATCH --job-name FermiKit
#SBATCH --error FermiKit.Errors.txt
#SBATCH --output FermiKit.Console.txt

/fermikit/fermi.kit/fermi2.pl unitig -t24 -s249m -p fermikit CHM1.fq  > fermikit.mak
make -f fermikit.mak
/fermikit/fermi.kit/run-calling -t24 genome.fa fermikit.mag.gz | sh
