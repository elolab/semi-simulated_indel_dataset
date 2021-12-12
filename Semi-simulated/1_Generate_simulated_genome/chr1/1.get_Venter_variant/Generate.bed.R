options(scipen=999)

Haplotype_1 <- read.table("Chr1.haplotype_1.variants_1.txt")
Haplotype_2 <- read.table("Chr1.haplotype_2.variants_1.txt")

Bed.haplotype_1 <- vector()
for (i in 1:dim(Haplotype_1)[1])
{
  print (i)
  item <- vector()
  if (as.character(Haplotype_1[i,1]=="deletion"))
  {
      item <- c("chr1",as.character(Haplotype_1[i,2]),as.character(as.numeric(as.character(Haplotype_1[i,2]))+
                                                                  as.numeric(as.character(Haplotype_1[i,3]))))
      Bed.haplotype_1 <- rbind(Bed.haplotype_1,item) 
  }
  if (as.character(Haplotype_1[i,1]=="insertion"))
  {
    item <- c("chr1",as.character(Haplotype_1[i,2]),as.numeric(as.character(Haplotype_1[i,2]))+1)
    Bed.haplotype_1 <- rbind(Bed.haplotype_1,item) 
  }
}
Bed.haplotype_1 <- data.frame(Bed.haplotype_1)

Bed.haplotype_2 <- vector()
for (i in 1:dim(Haplotype_2)[1])
{
  print (i)
  item <- vector()
  if (as.character(Haplotype_2[i,1]=="deletion"))
  {
    item <- c("chr1",as.character(Haplotype_2[i,2]),as.character(as.numeric(as.character(Haplotype_2[i,2]))+
                as.numeric(as.character(Haplotype_2[i,3]))))
    Bed.haplotype_2 <- rbind(Bed.haplotype_2,item) 
  }
  if (as.character(Haplotype_2[i,1]=="insertion"))
  {
    item <- c("chr1",as.character(Haplotype_2[i,2]),as.numeric(as.character(Haplotype_2[i,2]))+1)
    Bed.haplotype_2 <- rbind(Bed.haplotype_2,item) 
  }
}
Bed.haplotype_2 <- data.frame(Bed.haplotype_2)

write.table(Bed.haplotype_1,"Bed.haplotype_1.bed",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
write.table(Bed.haplotype_2,"Bed.haplotype_2.bed",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
