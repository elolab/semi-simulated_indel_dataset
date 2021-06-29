# semi-simulated_indel_dataset
The semi-simulated datasets (FASTQ files, semi-simulated FASTA files and indel truth set) can be downloaded from: https://doi.org/10.5281/zenodo.4630389

The semi-simulated datasets were generated based on reference sequence of human genome hg19 chromosome 1. Indels were adopted from HuRef (Levy S, Sutton G, Ng PC, et al. The diploid genome sequence of an individual human. PLoS Biol. 2007; 5:2113–2144) of chromosome 1.
1. The original HuRef indels were based on hg18 coordinates. We used UCSC genome browser lift-over tool to convert them to hg19 coordinates.
2. We normalized HuRef indels and filtered out inconsistent indels with a similar algorithm as vt tool (Tan A, Abecasis GR, Kang HM. Unified representation of genetic variants. Bioinformatics 2015). The details of dataset descriptions can be found in Ning, et al.
3. We removed gaps of reference sequence hg19 chromosome 1 based on the coordinate system of UCSC genome broswer.
4. We chose two subsets of variants to create heterozygous and homozygous variants the following way: one set of variants were inserted into one of the haplotypes (heterozygous variants) and the other set of variants were inserted into both haplotypes (homozygous variants).(The details can be found in Ning, et al)
5. We inserted HuRef indels by using svsim (https://github.com/mfranberg/svsim) with our modifications.
6. We created simulated sequencing reads using the NGS read simulation tool ART⁠ with three different coverages: 5X, 30X and 60X. The read length of simulated sequencing data was 100bp⁠⁠. In addition, we created another simulated sequencing dataset with 30X coverage and 250bp read length
7. For each dataset, the sequencing coverage was contributed by the two haplotypes with an approximate ratio of 1:1, making it representative of a naturally diploid sample.
