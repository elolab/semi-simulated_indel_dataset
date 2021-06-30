TDe10 <- read.table("Pindel_CHM1_TD.vcf")
chromosome_list <- c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13",
                     "chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX")
TDe10 <- TDe10[TDe10[,1] %in% chromosome_list,]
Pindel_dup_data <- vector()
Pindel_dup <- TDe10
for (i in 1:dim(Pindel_dup)[1])
{
  item <- vector()
  chromosome <- as.character(Pindel_dup[i,1])
  # get length information from INFO column
  position <- Pindel_dup[i,2]
  Pindel_dup_info<- strsplit(as.character(Pindel_dup[i,8]),";")[[1]]
  
  Pindel_dup_len <- Pindel_dup_info[grep("SVLEN=",Pindel_dup_info)]
  Pindel_dup_LEN <- substr(as.character(Pindel_dup_len),7,nchar(Pindel_dup_len)) # move "-" out
  
  Pindel_dup_END <- as.numeric(as.character(position))+as.numeric(as.character(Pindel_dup_LEN))
  
  item <- c(chromosome,position,Pindel_dup_LEN,Pindel_dup_END)
  Pindel_dup_data <- rbind(Pindel_dup_data,item)
}

Pindel_dup_data <- Pindel_dup_data[as.numeric(as.character(Pindel_dup_data[,3]))>=50,]
Pindel_dup_data <- Pindel_dup_data[,-3]










