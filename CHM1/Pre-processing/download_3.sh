#!/bin/sh
#SBATCH --cpus-per-task 32
#SBATCH --error download3.Error.txt
#SBATCH --output download3.Output.txt
#SBATCH --partition long
#SBATCH --job-name download


wget ftp://ftp.ddbj.nig.ac.jp/ddbj_database/dra/fastq/SRA161/SRA161528/SRX652547/SRR1514951_1.fastq.bz2
