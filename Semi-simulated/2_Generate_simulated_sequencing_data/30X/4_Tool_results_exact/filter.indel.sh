#!/bin/sh
#SBATCH --cpus-per-task 1
#SBATCH --error vcftools.Error.txt
#SBATCH --output vcftools.Output.txt
#SBATCH --partition short
#SBATCH --job-name v_135

/vcftools_0.1.13/bin/vcftools --vcf ./DeepVariant/output.vcf --keep-only-indels --min-alleles 2 --max-alleles 2 --recode --out ./DeepVariant/deepVariants
/vcftools_0.1.13/bin/vcftools --vcf ./DeepVariant/output.vcf --keep-only-indels --recode --out ./DeepVariant/out2

/vcftools_0.1.13/bin/vcftools --vcf ./FermiKit/fermikit.flt.vcf --keep-only-indels --min-alleles 2 --max-alleles 2 --recode --out ./FermiKit/fermikit.flt  
/vcftools_0.1.13/bin/vcftools --vcf ./FermiKit/fermikit.flt.vcf --keep-only-indels --recode --out ./FermiKit/out2

/vcftools_0.1.13/bin/vcftools --vcf ./GATK/GATK_R.vcf --keep-only-indels --min-alleles 2 --max-alleles 2 --recode --out ./GATK/GATK
/vcftools_0.1.13/bin/vcftools --vcf ./GATK/GATK_R.vcf --keep-only-indels --recode --out ./GATK/out2

/vcftools_0.1.13/bin/vcftools --vcf ./Platypus/variants.assembel.vcf --keep-only-indels --min-alleles 2 --max-alleles 2 --recode --out ./Platypus/assembel.indel
/vcftools_0.1.13/bin/vcftools --vcf ./Platypus/variants.assembel.vcf --keep-only-indels --recode --out ./Platypus/out3

/vcftools_0.1.13/bin/vcftools --vcf ./Strelka2/variants.vcf --keep-only-indels --min-alleles 2 --max-alleles 2 --recode --out ./Strelka2/variants.indel
/vcftools_0.1.13/bin/vcftools --vcf ./Strelka2/variants.vcf --keep-only-indels --recode --out ./Strelka2/out2

