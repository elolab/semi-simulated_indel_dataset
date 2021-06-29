#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --mem 32GB
#SBATCH -C stable
#SBATCH --job-name FermiKit.250

cat 2x250_Venter_read1.fq 2x250_Venter_read2.fq > fermikit.fq
/fermikit/fermi.kit/fermi2.pl unitig -t24 -s249m -l250 -p fermikit fermikit.fq  > fermikit.mak
make -f fermikit.mak
/fermikit/fermi.kit/run-calling -t24 chr1.fa fermikit.mag.gz | sh
