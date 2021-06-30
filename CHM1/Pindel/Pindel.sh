#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition long 
#SBATCH --job-name Pindel
#SBATCH -t 14-00:00:00

/pindel/pindel -i config.txt -f genome.fa -o Pindel_CHM1 -T 24 -x 5

/pindel/pindel2vcf -p Pindel_CHM1_D -r genome.fa -R hg19 -d 20200305 -v Pindel_CHM1_D.vcf -e 5

/pindel/pindel2vcf -p Pindel_CHM1_SI -r genome.fa -R hg19 -d 20200305 -v Pindel_CHM1_SI.vcf -e 5

/pindel/pindel2vcf -p Pindel_CHM1_LI -r genome.fa -R hg19 -d 20200305 -v Pindel_CHM1_LI.vcf -e 5

/pindel/pindel2vcf -p Pindel_CHM1_TD -r genome.fa -R hg19 -d 20200305 -v Pindel_CHM1_TD.vcf -e 5

