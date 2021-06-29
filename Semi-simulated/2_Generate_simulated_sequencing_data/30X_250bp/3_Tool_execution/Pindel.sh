#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --mem 32GB
#SBATCH -C stable
#SBATCH --job-name Pindel4.2x250

/pindel/pindel -i simulated_config.txt -f chr1.fa -o Pindel_simulatedD4 -T 24 -x 4 -M 4

/pindel/pindel2vcf -p Pindel_simulatedD4_D -r chr1.fa -R chr1 -d 20200204 -v Pindel_simulatedD4_D.vcf 

/pindel/pindel2vcf -p Pindel_simulatedD4_SI -r chr1.fa -R chr1 -d 20200204 -v Pindel_simulatedD4_SI.vcf 

/pindel/pindel2vcf -p Pindel_simulatedD4_LI -r chr1.fa -R chr1 -d 20200204 -v Pindel_simulatedD4_LI.vcf 

/pindel/pindel2vcf -p Pindel_simulatedD4_TD -r chr1.fa -R chr1 -d 20200204 -v Pindel_simulatedD4_TD.vcf 
