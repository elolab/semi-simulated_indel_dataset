#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition normal 
#SBATCH -C stable
#SBATCH --mem 32GB
#SBATCH --job-name Pindel.5
#SBATCH --error Pindel.5.Errors.txt
#SBATCH --output Pindel.5.Console.txt

export LD_LIBRARY_PATH
LD_LIBRARY_PATH=/htslib

/pindel/pindel -i simulated_config.txt -f reference_chr1_chr2.fa -o Pindel_simulatedD -T 24 -x 4 -M 2 -l

/pindel/pindel2vcf -p Pindel_simulatedD_D -r reference_chr1_chr2.fa -R reference_chr1_chr2 -d 20211030 -v Pindel_simulatedD_D.vcf -mc 2 -G

/pindel/pindel2vcf -p Pindel_simulatedD_SI -r reference_chr1_chr2.fa -R reference_chr1_chr2 -d 20211030 -v Pindel_simulatedD_SI.vcf -mc 2 -G

/pindel/pindel2vcf -p Pindel_simulatedD_LI -r reference_chr1_chr2.fa -R reference_chr1_chr2 -d 20211030 -v Pindel_simulatedD_LI.vcf -mc 2 -G

/pindel/pindel2vcf -p Pindel_simulatedD_TD -r reference_chr1_chr2.fa -R reference_chr1_chr2 -d 20211030 -v Pindel_simulatedD_TD.vcf -mc 2 -G
