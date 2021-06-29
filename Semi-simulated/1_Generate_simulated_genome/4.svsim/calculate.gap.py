Haplotype_1 = open("/home/kning/seagate/clean_clean_genome/Haplotype_1.fa","r")
Haplotype_1_no_gap = open("/home/kning/seagate/clean_clean_genome/Haplotype_1_no_gap.fa","w")
data = Haplotype_1.read().replace('N', '') # the first 5 is ">chr1"
Haplotype_1_no_gap.write(data)
Haplotype_1.close()
Haplotype_1_no_gap.close()

Haplotype_2 = open("/home/kning/seagate/clean_clean_genome/Haplotype_2.fa","r")
Haplotype_2_no_gap = open("/home/kning/seagate/clean_clean_genome/Haplotype_2_no_gap.fa","w")
data2 = Haplotype_2.read().replace('N', '') 
Haplotype_2_no_gap.write(data2)
Haplotype_2.close()
Haplotype_2_no_gap.close()

#rsync -v -a --bwlimit=30000 /home/kning/Bio/Indels_calling/mfranberg_simulated/Venter ningwang@head02.btk.fi:/elo/genomics/netapp/B18010_SV_genome
