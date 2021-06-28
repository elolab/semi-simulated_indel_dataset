haplotype_1 <- read.table("chr1.haplotype_1.hg19.txt")
haplotype_2 <- read.table("chr1.haplotype_2.hg19.txt")

homo <- haplotype_1[haplotype_1[,5]=="1/1",]
heter_1 <- haplotype_1[haplotype_1[,5]=="1/0",]
heter_2 <- haplotype_2[haplotype_2[,5]=="0/1",]

variants <- rbind(homo,heter_1,heter_2)
variants <- variants[order(variants[,2]),]
rownames(variants) <- seq(length=nrow(variants))
write.table(variants,"Venter.truthset.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")





















