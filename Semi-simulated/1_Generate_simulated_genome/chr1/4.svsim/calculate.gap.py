Haplotype_1 = open("Haplotype_1.fa","r")
Haplotype_1_no_gap = open("Haplotype_1_no_gap_chr1.fa","w")
data = Haplotype_1.read().replace('N', '') 
Haplotype_1_no_gap.write(data)
Haplotype_1.close()
Haplotype_1_no_gap.close()

Haplotype_2 = open("Haplotype_2.fa","r")
Haplotype_2_no_gap = open("Haplotype_2_no_gap_chr1.fa","w")
data2 = Haplotype_2.read().replace('N', '') 
Haplotype_2_no_gap.write(data2)
Haplotype_2.close()
Haplotype_2_no_gap.close()