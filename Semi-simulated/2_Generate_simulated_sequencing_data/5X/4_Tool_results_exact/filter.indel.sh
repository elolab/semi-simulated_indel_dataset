#!/bin/sh
#SBATCH --cpus-per-task 1
#SBATCH --error vcftools.Error.txt
#SBATCH --output vcftools.Output.txt
#SBATCH --partition short
#SBATCH --job-name vcftools

#DeepVariant
vcftools --vcf DP.vcf --keep-only-indels --min-alleles 2 --max-alleles 2 --recode --out deepvariants  
vcftools --vcf DP.vcf --keep-only-indels --recode --out out2

# FermiKit
vcftools --vcf fermikit.flt.vcf --keep-only-indels --min-alleles 2 --max-alleles 2 --recode --out fermikit.flt  
vcftools --vcf fermikit.flt.vcf --keep-only-indels --recode --out out2

#GATK
vcftools --vcf GATK_R.vcf --keep-only-indels --min-alleles 2 --max-alleles 2 --recode --out .GATK
vcftools --vcf GATK_R.vcf --keep-only-indels --recode --out out2

#Platypus
vcftools --vcf variants.vcf --keep-only-indels --min-alleles 2 --max-alleles 2 --recode --out variants.indel    
vcftools --vcf variants.vcf --keep-only-indels --recode --out out2

#Platypus_A
vcftools --vcf variants.assembel.vcf --keep-only-indels --min-alleles 2 --max-alleles 2 --recode --out ./Platypus/assembel.indel
vcftools --vcf variants.assembel.vcf --keep-only-indels --recode --out ./Platypus/out3

#Strelka2
vcftools --vcf variants.vcf --keep-only-indels --min-alleles 2 --max-alleles 2 --recode --out ./Strelka2/variants.indel
vcftools --vcf ./Strelka2/variants.vcf --keep-only-indels --recode --out ./Strelka2/out2

