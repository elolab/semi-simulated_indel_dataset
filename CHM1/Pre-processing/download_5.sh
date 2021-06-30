#!/bin/sh
#SBATCH --cpus-per-task 32
#SBATCH --error download5.Error.txt
#SBATCH --output download5.Output.txt
#SBATCH --partition long
#SBATCH --job-name download

wget ftp://ftp.ddbj.nig.ac.jp/ddbj_database/dra/fastq/SRA161/SRA161528/SRX652547/SRR1514952_1.fastq.bz2
