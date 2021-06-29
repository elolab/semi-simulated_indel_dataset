#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition normal 
#SBATCH --job-name Pindel.30
#SBATCH --error Pindel.30.Errors.txt
#SBATCH --output Pindel.30.Console.txt

/pindel/pindel -i Pindel_config.txt -f chr1.fa -o Pindel_simulatedD -T 24 -x 4 -M 4

/pindel/pindel2vcf -p Pindel_simulatedD_D -r chr1.fa -R chr1 -d 20190304 -v Pindel_simulatedD_D.vcf 

/pindel/pindel2vcf -p Pindel_simulatedD_SI -r chr1.fa -R chr1 -d 20190304 -v Pindel_simulatedD_SI.vcf 

/pindel/pindel2vcf -p Pindel_simulatedD_LI -r chr1.fa -R chr1 -d 20190304 -v Pindel_simulatedD_LI.vcf 

/pindel/pindel2vcf -p Pindel_simulatedD_TD -r chr1.fa -R chr1 -d 20190304 -v Pindel_simulatedD_TD.vcf 
