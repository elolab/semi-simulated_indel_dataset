Pindel_del <- read.table("Pindel_CHM1_D.vcf")
chromosome_list <- c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13",
                     "chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX")
Pindel_del <- Pindel_del[Pindel_del[,1] %in% chromosome_list,]

Pindel_del_INFO <- strsplit(as.character(Pindel_del[,8]),";")
Pindel_del_data <- vector()
for (i in 1:dim(Pindel_del)[1])
{
  print (i)
  item <- vector()
  chromosome <- as.character(Pindel_del[i,1])
  # get length information from INFO column
  position <- Pindel_del[i,2]
  Pindel_del_info<- Pindel_del_INFO[i][[1]]
  
  Pindel_del_len <- Pindel_del_info[grep("SVLEN=",Pindel_del_info)]
  Pindel_del_LEN <- substr(as.character(Pindel_del_len),8,nchar(Pindel_del_len)) # move "-" out
  
  Pindel_del_end <- Pindel_del_info[grep("END=",Pindel_del_info)]
  Pindel_del_END <- substr(as.character(Pindel_del_end),5,nchar(Pindel_del_end)) # move "-" out
  
  item <- c(chromosome,position,Pindel_del_LEN,Pindel_del_END)
  Pindel_del_data <- rbind(Pindel_del_data,item)
}

Pindel_del_data <- Pindel_del_data[as.numeric(as.character(Pindel_del_data[,3]))>=50,]
Pindel_del_data <- Pindel_del_data[,-3]

write.table(Pindel_del_data,"Pindel_deletion.bed",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")

De10_del_data <- read.table("Pindel_deletion.bed")
De10_length <- as.numeric(as.character(De10_del_data[,3]))-as.numeric(as.character(De10_del_data[,2]))
De10_del_data <- cbind(De10_del_data,De10_length)
De10_del_data_50 <- De10_del_data[as.numeric(as.character(De10_del_data[,4]))>=50 
                                    & as.numeric(as.character(De10_del_data[,4]))<500,]
De10_del_data_1000 <- De10_del_data[as.numeric(as.character(De10_del_data[,4]))>=500,] 
                                      



































