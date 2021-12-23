#!/bin/sh
#SBATCH --cpus-per-task 24
#SBATCH --partition long
#SBATCH --mem 32GB
#SBATCH --job-name GATK.WGS
#SBATCH --error GATK.WGS.Errors.txt
#SBATCH --output GATK.WGS.Console.txt

java -jar /wrk/sofia/local/Ning/software/software1/Picard.Tools/Install.Dir/picard.jar AddOrReplaceReadGroups I=CHM1.SAM.SORTED.BAM O=RG.CHM1.SAM.SORTED.BAM RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20

/wrk/epouta1/B18010_indel_tool_evaluation/Ning/Ning/software/software2/gatk-4.0.1.2/gatk HaplotypeCaller -R /data/references/deprecated.iGenomes/homo_sapiens/hg19/UCSC/hg19/Sequence/WholeGenomeFasta/genome.fa -I /data/epouta1/B18010_indel_tool_evaluation/CHM1/CHM1/RG.CHM1.SAM.SORTED.BAM -O GATK_WGS.vcf  

