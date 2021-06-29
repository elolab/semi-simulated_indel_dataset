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

Strelka2 <- read.table("variants.indel.recode.vcf")
Strelka2 <- rbind(Strelka2,Split_allele)
Strelka2 <- Strelka2[order(as.numeric(Strelka2[,2])),]

Strelka2_ins <- Strelka2[nchar(as.character(Strelka2[,5]))-nchar(as.character(Strelka2[,4]))>=1,]
Strelka2_del <- Strelka2[nchar(as.character(Strelka2[,4]))-nchar(as.character(Strelka2[,5]))>=1,]

Strelka2_ins_data <- vector()
for (i in 1:dim(Strelka2_ins)[1])
{
  item <- vector()
  position <- as.numeric(Strelka2_ins[i,2])
  length <-  abs(nchar(as.character(Strelka2_ins[i,4])) - nchar(as.character(Strelka2_ins[i,5])))
  item_geno <- strsplit(as.character(Strelka2_ins[i,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(position,length,item_geno)
  Strelka2_ins_data <- rbind(Strelka2_ins_data,item)
}

Strelka2_del_data <- vector()
for (i in 1:dim(Strelka2_del)[1])
{
  item <- vector()
  position <- as.numeric(Strelka2_del[i,2])
  length <-  abs(nchar(as.character(Strelka2_del[i,4])) - nchar(as.character(Strelka2_del[i,5])))
  item_geno <- strsplit(as.character(Strelka2_del[i,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(position,length,item_geno)
  Strelka2_del_data <- rbind(Strelka2_del_data,item)
}

Strelka2_ins_data <- data.frame(Strelka2_ins_data)
Strelka2_del_data <- data.frame(Strelka2_del_data)

write.table(Strelka2_del_data,"deletion_result.txt",row.names = F,col.names = F,quote = F)
write.table(Strelka2_ins_data,"insertion_result.txt",row.names = F,col.names = F,quote = F)

























