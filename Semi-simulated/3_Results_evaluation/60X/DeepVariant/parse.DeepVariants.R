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

DeepVariant_sv <- read.table("deepvariants.recode.vcf")
DeepVariant_sv <- rbind(DeepVariant_sv,Split_allele)
DeepVariant_sv <- DeepVariant_sv[order(as.numeric(DeepVariant_sv[,2])),]

DeepVariant_ins <- DeepVariant_sv[nchar(as.character(DeepVariant_sv[,5]))-nchar(as.character(DeepVariant_sv[,4]))>=1,]
DeepVariant_del <- DeepVariant_sv[nchar(as.character(DeepVariant_sv[,4]))-nchar(as.character(DeepVariant_sv[,5]))>=1,]

DeepVariant_ins1 <- vector()
DeepVariant_del1 <- vector()
for (j in 1:dim(DeepVariant_ins)[1])
{
  item <- vector()
  input_len <- nchar(as.character(DeepVariant_ins[j,5]))-nchar(as.character(DeepVariant_ins[j,4])) 
  item_geno <- strsplit(as.character(DeepVariant_ins[j,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(DeepVariant_ins[j,2],input_len,item_geno)
  DeepVariant_ins1 <- rbind(DeepVariant_ins1,item)
}
for (j in 1:dim(DeepVariant_del)[1])
{
  item <- vector()
  input_len <- nchar(as.character(DeepVariant_del[j,4]))-nchar(as.character(DeepVariant_del[j,5])) # deletion length is column 4 
  item_geno <- strsplit(as.character(DeepVariant_del[j,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(DeepVariant_del[j,2],input_len,item_geno)
  DeepVariant_del1 <- rbind(DeepVariant_del1,item)
}
DeepVariant_del1 <- data.frame(DeepVariant_del1)
DeepVariant_ins1 <- data.frame(DeepVariant_ins1)
write.table(DeepVariant_del1,"deletion_result.txt",row.names = F,col.names = F,quote = F)
write.table(DeepVariant_ins1,"insertion_result.txt",row.names = F,col.names = F,quote = F)
























































