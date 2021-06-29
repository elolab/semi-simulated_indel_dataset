De5 <- read.table("Pindel_simulatedD4_D.vcf")

# split into subsets
Pindel_del_data <- vector()
Pindel_del <- De5
for (i in 1:dim(Pindel_del)[1])
{
  item <- vector()
  # get length information from INFO column
  position <- Pindel_del[i,2]
  Pindel_del_info<- strsplit(as.character(Pindel_del[i,8]),";")[[1]]
  Pindel_del_len <- Pindel_del_info[grep("SVLEN=",Pindel_del_info)]
  Pindel_del_LEN <- substr(as.character(Pindel_del_len),8,nchar(Pindel_del_len)) 
  geno <- strsplit(as.character(Pindel_del[i,10]),":")[[1]][1]
  if (geno=="1/0")
  {
    geno <- "0/1"
  }
  item <- c(position,Pindel_del_LEN,geno)
  Pindel_del_data <- rbind(Pindel_del_data,item)
}
Pindel_del_data <- data.frame(Pindel_del_data)

TDe10 <- read.table("Pindel_simulatedD4_TD.vcf")

# split into sunsets
Pindel_dup_data <- vector()
Pindel_dup <- TDe10
for (i in 1:dim(Pindel_dup)[1])
{
  item <- vector()
  # get length information from INFO column
  position <- Pindel_dup[i,2]
  Pindel_dup_info<- strsplit(as.character(Pindel_dup[i,8]),";")[[1]]
  Pindel_dup_len <- Pindel_dup_info[grep("SVLEN=",Pindel_dup_info)]
  Pindel_dup_LEN <- substr(as.character(Pindel_dup_len),7,nchar(Pindel_dup_len)) 
  geno <- strsplit(as.character(Pindel_dup[i,10]),":")[[1]][1]
  if (geno=="1/0")
  {
    geno <- "0/1"
  }
  item <- c(position,Pindel_dup_LEN,geno)
  Pindel_dup_data <- rbind(Pindel_dup_data,item)
}
Pindel_dup_data <- data.frame(Pindel_dup_data)

SIe5 <- read.table("Pindel_simulatedD4_SI.vcf")

Pindel_ins_data <- vector()
for (i in 1:dim(SIe5)[1])
{
  item <- vector()
  # get length information from INFO column
  position <- SIe5[i,2]
  Pindel_ins_info<- strsplit(as.character(SIe5[i,8]),";")[[1]]
  Pindel_ins_len <- Pindel_ins_info[grep("SVLEN=",Pindel_ins_info)]
  Pindel_ins_LEN <- substr(as.character(Pindel_ins_len),7,nchar(Pindel_ins_len))
  geno <- strsplit(as.character(SIe5[i,10]),":")[[1]][1]
  if (geno=="1/0")
  {
    geno <- "0/1"
  }
  item <- c(position,Pindel_ins_LEN,geno)
  Pindel_ins_data <- rbind(Pindel_ins_data,item)
}
Pindel_ins_data <- data.frame(Pindel_ins_data)
Pindel_ins_data <- rbind(Pindel_ins_data,Pindel_dup_data)

write.table(Pindel_del_data,"deletion_result.txt",row.names = F,col.names = F,quote = F)
write.table(Pindel_ins_data ,"insertion_result.txt",row.names = F,col.names = F,quote = F)

































































