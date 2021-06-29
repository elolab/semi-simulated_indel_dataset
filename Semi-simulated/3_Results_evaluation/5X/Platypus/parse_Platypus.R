raw_input <- read.table("out3.recode.vcf")

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

Platypus_input <- read.table("assembel.indel.recode.vcf")
Platypus_input <- rbind(Platypus_input,Split_allele)
Platypus_input <- Platypus_input[order(as.numeric(Platypus_input[,2])),]

Platypus_ins <- Platypus_input[nchar(as.character(Platypus_input[,5]))-nchar(as.character(Platypus_input[,4]))>=1,]
Platypus_del <- Platypus_input[nchar(as.character(Platypus_input[,4]))-nchar(as.character(Platypus_input[,5]))>=1,]
what <- Platypus_input[nchar(as.character(Platypus_input[,4])) == nchar(as.character(Platypus_input[,5])),]
# get some SNV, which can be false positive

Platypus_ins_data <- vector()
for (i in 1:dim(Platypus_ins)[1])
{
  item <- vector()
  position <- as.numeric(Platypus_ins[i,2])
  length <-  abs(nchar(as.character(Platypus_ins[i,4])) - nchar(as.character(Platypus_ins[i,5])))
  item_geno <- strsplit(as.character(Platypus_ins[i,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(position,length,item_geno)
  Platypus_ins_data <- rbind(Platypus_ins_data,item)
}

Platypus_del_data <- vector()
for (i in 1:dim(Platypus_del)[1])
{
  item <- vector()
  position <- as.numeric(Platypus_del[i,2])
  length <-  abs(nchar(as.character(Platypus_del[i,4])) - nchar(as.character(Platypus_del[i,5])))
  item_geno <- strsplit(as.character(Platypus_del[i,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(position,length,item_geno)
  Platypus_del_data <- rbind(Platypus_del_data,item)
}

Platypus_del_data <- data.frame(Platypus_del_data)
Platypus_ins_data <- data.frame(Platypus_ins_data)

write.table(Platypus_del_data,"deletion_result.txt",row.names = F,col.names = F,quote = F)
write.table(Platypus_ins_data,"insertion_result.txt",row.names = F,col.names = F,quote = F)












