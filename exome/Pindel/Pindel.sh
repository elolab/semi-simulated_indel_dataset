#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition long
#SBATCH --job-name Pindel.hg100
#SBATCH --error Pindel.5.Errors.txt
#SBATCH --output Pindel.5.Console.txt

/pindel/pindel -i config.txt -j exome-target-region.bed -f hs37d5.fa -o Pindel -T 24 -x 1 -M 18

/pindel/pindel2vcf -p Pindel_D -r hs37d5.fa -R hs37d5  -d 20190322 -v Pindel_D.vcf

/pindel/pindel2vcf -p Pindel_SI -r hs37d5.fa -R hs37d5  -d 20190322 -v Pindel_SI.vcf 

/pindel/pindel2vcf -p Pindel_LI -r hs37d5.fa -R hs37d5  -d 20190322 -v Pindel_LI.vcf 

/pindel/pindel2vcf -p Pindel_TD -r hs37d5.fa -R hs37d5  -d 20190322 -v Pindel_TD.vcf 
