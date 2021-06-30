#!/bin/sh
#SBATCH --cpus-per-task 32
#SBATCH --error download1.Error.txt
#SBATCH --output download1.Output.txt
#SBATCH --partition long
#SBATCH --job-name download

wget ftp://ftp.ddbj.nig.ac.jp/ddbj_database/dra/fastq/SRA161/SRA161528/SRX652547/SRR1514950_1.fastq.bz2
