Haplotype.1 <- read.table("Chr1.haplotype_1.variants_1.txt")
Bed.1 <- read.table("hglft_genome_1.bed")
for (i in 1:dim(Haplotype.1)[1])
{
  print (i)
  Haplotype.1[i,2] <- Bed.1[i,2]
}

Haplotype.2 <- read.table("Chr1.haplotype_2.variants_1.txt")
Bed.2 <- read.table("hglft_genome_2.bed")
for (i in 1:dim(Haplotype.2)[1])
{
  print (i)
  Haplotype.2[i,2] <- Bed.2[i,2]
}

write.table(Haplotype.1,"chr1.haplotype_1.hg19.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
write.table(Haplotype.2,"chr1.haplotype_2.hg19.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")

Haplotype.1.svsim <- Haplotype.1[,c(1,2,3)]
Haplotype.2.svsim <- Haplotype.2[,c(1,2,3)]
write.table(Haplotype.1.svsim,"svsim.chr1.haplotype_1.hg19.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
write.table(Haplotype.2.svsim,"svsim.chr1.haplotype_2.hg19.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
