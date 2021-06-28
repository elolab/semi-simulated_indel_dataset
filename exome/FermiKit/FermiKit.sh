#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition long 
#SBATCH --job-name FermiKit.S
#SBATCH --error FermiKit.S.Errors.txt
#SBATCH --output FermiKit.S.Console.txt

cat SRR2962669_1.fastq.gz SRR2962669_2.fastq.gz > fermikit.fq.gz

/fermikit/fermi.kit/fermi2.pl unitig -t24 -s249m -l126 -p fermikit fermikit.fq.gz  > fermikit.mak
make -f fermikit.mak
/fermikit/fermi.kit/run-calling -t24 hs37d5.fa fermikit.mag.gz | sh
