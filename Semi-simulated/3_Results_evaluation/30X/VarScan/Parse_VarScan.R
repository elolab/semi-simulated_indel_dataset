VarScan <- read.table("varscan_indel.vcf")

VarScan_indel <- VarScan[nchar(as.character(VarScan[,4])) > 1 | nchar(as.character(VarScan[,5])) > 1,]
rownames(VarScan_indel) <- seq(length=nrow(VarScan_indel))# reset row name
VarScan_indel_del <- VarScan_indel[nchar(as.character(VarScan_indel[,4])) > 1,]
VarScan_indel_ins <- VarScan_indel[nchar(as.character(VarScan_indel[,5])) > 1,]
# make all indels together
VarScan_indel_ins1 <- vector()
VarScan_indel_del1 <- vector()
for (j in 1:dim(VarScan_indel_ins)[1])
{
  item <- vector()
  input_len <- nchar(as.character(VarScan_indel_ins[j,5]))-nchar(as.character(VarScan_indel_ins[j,4]))
  item_geno <- strsplit(as.character(VarScan_indel_ins[j,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(VarScan_indel_ins[j,2],input_len,item_geno)
  VarScan_indel_ins1 <- rbind(VarScan_indel_ins1,item)
}
for (j in 1:dim(VarScan_indel_del)[1])
{
  item <- vector()
  input_len <- nchar(as.character(VarScan_indel_del[j,4]))-nchar(as.character(VarScan_indel_del[j,5]))
  item_geno <- strsplit(as.character(VarScan_indel_del[j,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(VarScan_indel_del[j,2],input_len,item_geno)
  VarScan_indel_del1 <- rbind(VarScan_indel_del1,item)
}

VarScan_indel_del1 <- data.frame(VarScan_indel_del1)
VarScan_indel_ins1 <- data.frame(VarScan_indel_ins1)

write.table(VarScan_indel_del1,"deletion_result.txt",row.names = F,col.names = F,quote = F)
write.table(VarScan_indel_ins1,"insertion_result.txt",row.names = F,col.names = F,quote = F)




