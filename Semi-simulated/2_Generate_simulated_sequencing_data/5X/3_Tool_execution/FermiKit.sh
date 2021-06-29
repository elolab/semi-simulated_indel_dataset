#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition normal 
#SBATCH --job-name FermiKit.5
#SBATCH --error FermiKit.5.Errors.txt
#SBATCH --output FermiKit.5.Console.txt

cat 5X_Venter_read1.fq 5X_Venter_read2.fq > fermikit.fq
/fermikit/fermi.kit/fermi2.pl unitig -t24 -s249m -l100 -p fermikit fermikit.fq  > fermikit.mak
make -f fermikit.mak
/fermikit/fermi.kit/run-calling -t24 chr1.fa fermikit.mag.gz | sh
