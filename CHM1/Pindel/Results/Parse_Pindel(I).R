SIe5 <- read.table("Pindel_CHM1_SI.vcf")
chromosome_list <- c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13",
                     "chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX")
SIe5 <- SIe5[SIe5[,1] %in% chromosome_list,]
Pindel_ins_data <- vector()
Pindel_ins <- SIe5
for (i in 1:dim(Pindel_ins)[1])
{
  print (i)
  item <- vector()
  chromosome <- as.character(Pindel_ins[i,1])
  # get length information from INFO column
  position <- Pindel_ins[i,2]
  Pindel_ins_info<- strsplit(as.character(Pindel_ins[i,8]),";")[[1]]
  
  Pindel_ins_len <- Pindel_ins_info[grep("SVLEN=",Pindel_ins_info)]
  Pindel_ins_LEN <- substr(as.character(Pindel_ins_len),7,nchar(Pindel_ins_len)) # move "-" out
  
  Pindel_ins_END <- as.numeric(as.character(position))+as.numeric(as.character(Pindel_ins_LEN))
  
  item <- c(chromosome,position,Pindel_ins_LEN,Pindel_ins_END)
  Pindel_ins_data <- rbind(Pindel_ins_data,item)
}

Pindel_ins_data <- Pindel_ins_data[as.numeric(as.character(Pindel_ins_data[,3]))>=50,]
Pindel_ins_data <- Pindel_ins_data[,-3]

SIe5 <- rbind(Pindel_ins_data,Pindel_dup_data)
SIe5 <- SIe5[order(SIe5[,1]),]
write.table(SIe5,"Pindel_insertion.bed",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")

SIe5 <- read.table("Pindel_insertion.bed")
SIe5_length <- as.numeric(as.character(SIe5[,3]))-as.numeric(as.character(SIe5[,2]))
SIe5 <- cbind(SIe5,SIe5_length)

SIe5_50 <- SIe5[as.numeric(as.character(SIe5[,4]))>=50 
                                    & as.numeric(as.character(SIe5[,4]))<500,]
SIe5_1000 <- SIe5[as.numeric(as.character(SIe5[,4]))>=500,]
                                      

















