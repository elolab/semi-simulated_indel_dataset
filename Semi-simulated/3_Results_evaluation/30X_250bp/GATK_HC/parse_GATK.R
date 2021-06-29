raw_input <- read.table("out2.recode.vcf")

Bio_allele <- raw_input[grepl(",",as.character(raw_input[,5])),]
Split_allele <- vector()
for (i in 1:dim(Bio_allele)[1])
{
  head <- Bio_allele[i,1:4]
  trail <- Bio_allele[i,6:10]
  V5 <- strsplit(as.character(Bio_allele[i,5]), ",")[[1]][1]
  Record_1 <- cbind(head,V5,trail)
  V5 <- strsplit(as.character(Bio_allele[i,5]), ",")[[1]][2]
  Record_2 <- cbind(head,V5,trail)
  Split_allele <- rbind(Split_allele,Record_1)
  Split_allele <- rbind(Split_allele,Record_2)
}

GATK <- read.table("GATK.recode.vcf")
GATK <- rbind(GATK,Split_allele)
GATK <- GATK[order(as.numeric(GATK[,2])),]

GATK_indel <- GATK[nchar(as.character(GATK[,4])) > 1 | nchar(as.character(GATK[,5])) > 1,]
rownames(GATK_indel) <- seq(length=nrow(GATK_indel))# reset row name
GATK_indel_del <- GATK_indel[nchar(as.character(GATK_indel[,4])) -nchar(as.character(GATK_indel[,5])) >= 1,]
GATK_indel_ins <- GATK_indel[nchar(as.character(GATK_indel[,5])) - nchar(as.character(GATK_indel[,4])) >= 1,]
# make all indels together
GATK_indel_ins1 <- vector()
GATK_indel_del1 <- vector()
for (j in 1:dim(GATK_indel_ins)[1])
{
  item <- vector()
  input_len <- nchar(as.character(GATK_indel_ins[j,5]))-nchar(as.character(GATK_indel_ins[j,4]))
  item_geno <- strsplit(as.character(GATK_indel_ins[j,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(GATK_indel_ins[j,2],input_len,item_geno)
  GATK_indel_ins1 <- rbind(GATK_indel_ins1,item)
}
for (j in 1:dim(GATK_indel_del)[1])
{
  item <- vector()
  input_len <- nchar(as.character(GATK_indel_del[j,4]))-nchar(as.character(GATK_indel_del[j,5]))
  item_geno <- strsplit(as.character(GATK_indel_del[j,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(GATK_indel_del[j,2],input_len,item_geno)
  GATK_indel_del1 <- rbind(GATK_indel_del1,item)
}
GATK_indel_del1 <- data.frame(GATK_indel_del1)
GATK_indel_ins1 <- data.frame(GATK_indel_ins1)

write.table(GATK_indel_del1,"deletion_result.txt",row.names = F,col.names = F,quote = F)
write.table(GATK_indel_ins1,"insertion_result.txt",row.names = F,col.names = F,quote = F)














