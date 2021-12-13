#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition normal
#SBATCH -C stable
#SBATCH --mem 32GB
#SBATCH --job-name Delly.5
#SBATCH --error Delly.5.Errors.txt
#SBATCH --output Delly.5.Console.txt

export LD_LIBRARY_PATH
LD_LIBRARY_PATH=/htslib
/delly/src/delly call -g reference_chr1_chr2.fa RG.100bp_5X_500.BWA-M.SORTED.SAM.bam -i -o delly_default.bcf

/delly/bcftools/bcftools view delly_default.bcf > delly_default.vcf
