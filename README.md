# semi-simulated_indel_dataset
Semi-simulated indel dataset

The semi-simulated datasets can be downloaded from: LINKS

The semi-simulated datasets were generated based on reference sequence of human genome hg19 chromosome 1. Variants were adopted from HuRef (Levy S, Sutton G, Ng PC, et al. The diploid genome sequence of an individual human. PLoS Biol. 2007; 5:2113–2144) of chromosome 1. We only picked indels from HuRef.
1. The original HuRef indels were based on hg18, we first used UCSC genome broswer lift-over tool to convert it to hg19 coordinates.
2. We normalized HuRef indels and filter out inconsistent indels with the similar algorithm as vt tool (Tan A, Abecasis GR, Kang HM. Unified representation of genetic variants. Bioinformatics 2015). The details of datasets descriptions can be found in Ning, et al. 
3. We removed gaps of reference sequence hg19 chromosome 1 based on the coordinations from UCSC genome broswer.
4. we chose two subsets of variants and only inserted them into one of the haplotypes (The details can be found in Ning, et al). Then the remaining variants were inserted into both of the haplotypes. These variants are treated as heterozygous and homozygous variants, respectively.
5. We inserted HuRef indels by using svsim (https://github.com/mfranberg/svsim) with our modification
6. We created simulated sequencing reads using the NGS read simulation tool ART⁠ with three different coverages: 5X, 30X and 60X. The read length of simulated sequencing data was 100bp⁠⁠. In addition, we created another simulated sequencing dataset with 30X coverage and 250bp read length
7. For each dataset, the sequencing coverage was contributed by the two haplotypes with an approximate ratio of 1:1, making it representative of a naturally diploid sample.
