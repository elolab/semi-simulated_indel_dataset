#!/bin/sh
#SBATCH --cpus-per-task 1
#SBATCH --job-name vcftools

#DeepVariant
/vcftools/src/cpp/vcftools --vcf RG.2x250.BWA-M.SORTED.dv-0.7.0.output.vcf --keep-only-indels --min-alleles 2 --max-alleles 2 --recode --out deepvariants_070
/vcftools/src/cpp/vcftools --vcf RG.2x250.BWA-M.SORTED.dv-0.7.0.output.vcf --keep-only-indels --recode --out out2_070

#FermiKit
/vcftools/src/cpp/vcftools --vcf fermikit.flt.vcf --keep-only-indels --min-alleles 2 --max-alleles 2 --recode --out fermikit.flt  
/vcftools/src/cpp/vcftools --vcf fermikit.flt.vcf --keep-only-indels --recode --out out2

#GATK
/vcftools/src/cpp/vcftools --vcf GATK_R.vcf --keep-only-indels --min-alleles 2 --max-alleles 2 --recode --out GATK
/vcftools/src/cpp/vcftools --vcf GATK_R.vcf --keep-only-indels --recode --out out2

#Platypus
/vcftools/src/cpp/vcftools --vcf variants.vcf --keep-only-indels --min-alleles 2 --max-alleles 2 --recode --out ariants.indel    
/vcftools/src/cpp/vcftools --vcf variants.vcf --keep-only-indels --recode --out out2

#Platypus_A
/vcftools/src/cpp/vcftools --vcf variants.assembel.vcf --keep-only-indels --min-alleles 2 --max-alleles 2 --recode --out assembel.indel
/vcftools/src/cpp/vcftools --vcf variants.assembel.vcf --keep-only-indels --recode --out out3

#Strelka2
/vcftools/src/cpp/vcftools --vcf variants.vcf --keep-only-indels --min-alleles 2 --max-alleles 2 --recode --out variants.indel
/vcftools/src/cpp/vcftools --vcf variants.vcf --keep-only-indels --recode --out out2

