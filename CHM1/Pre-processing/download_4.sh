#!/bin/sh
#SBATCH --cpus-per-task 32
#SBATCH --error download4.Error.txt
#SBATCH --output download4.Output.txt
#SBATCH --partition long
#SBATCH --job-name download

wget ftp://ftp.ddbj.nig.ac.jp/ddbj_database/dra/fastq/SRA161/SRA161528/SRX652547/SRR1514951_2.fastq.bz2
