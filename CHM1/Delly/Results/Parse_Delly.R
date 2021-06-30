Delly_input <- read.table("delly_WGS.vcf")
Delly_input <- Delly_input[Delly_input[,7]=="PASS",]
chromosome_list <- c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13",
                     "chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX")
Delly_input <- Delly_input[Delly_input[,1] %in% chromosome_list,]
Delly_ins <- vector()
Delly_del <- vector()
Delly_dup <- vector()
for (i in 1:dim(Delly_input)[1])
{
  Delly_input_info <- strsplit(as.character(Delly_input[i,8]),";")[[1]]
  Delly_input_type <- Delly_input_info[grep("SVTYPE=",Delly_input_info)]
  Delly_input_TYPE <- substr(as.character(Delly_input_type),8,nchar(Delly_input_type))
  if (strsplit(as.character(Delly_input[i,8]),";")[[1]][1]=="PRECISE")
  {
    if (Delly_input_TYPE == "DEL")
    {
      Delly_del <- rbind(Delly_del,Delly_input[i,])
    }
    else if (Delly_input_TYPE == "INS")
    {
      Delly_ins <- rbind(Delly_ins,Delly_input[i,])
    }
    else if (Delly_input_TYPE == "DUP")
    {
      Delly_dup <- rbind(Delly_dup,Delly_input[i,])
    }
  }
}

Delly_del_data <- vector()
for (i in 1:dim(Delly_del)[1])
{
  item <- vector()
  # get length information from INFO column
  chromosome <- as.character(Delly_del[i,1])
  position <- as.numeric(as.character(Delly_del[i,2]))
  Delly_del_SV_start <- as.numeric(as.character(Delly_del[i,2]))
  Delly_del_info <- strsplit(as.character(Delly_del[i,8]),";")[[1]]
  
  Delly_del_input_end <- Delly_del_info[grep("END=",Delly_del_info)][1]
  Delly_del_SV_END <- as.numeric(substr(as.character(Delly_del_input_end),5,nchar(Delly_del_input_end)))
  
  Delly_del_CIPOS <- Delly_del_info[grep("CIPOS=",Delly_del_info)][1]
  Delly_del_SV_CIPOS <- as.numeric(substr(as.character(Delly_del_CIPOS),8,gregexpr(pattern =',',Delly_del_CIPOS)[[1]][1]-1))
  
  Delly_del_CIEND <- Delly_del_info[grep("CIEND=",Delly_del_info)][1]
  Delly_del_SV_CIEND <- as.numeric(substr(as.character(Delly_del_CIEND),8,gregexpr(pattern =',',Delly_del_CIEND)[[1]][1]-1))
  
  Delly_del_SV_start1 <- Delly_del_SV_start-Delly_del_SV_CIPOS
  Delly_del_SV_END2 <- Delly_del_SV_END+Delly_del_SV_CIEND
  
  item <- c(chromosome,Delly_del_SV_start1,Delly_del_SV_END2)
  Delly_del_data <- rbind(Delly_del_data,item)
}
Delly_length <- as.numeric(as.character(Delly_del_data[,3]))-as.numeric(as.character(Delly_del_data[,2]))
Delly_del_data <- cbind(Delly_del_data,Delly_length)
Delly_del_data_50 <- Delly_del_data[as.numeric(as.character(Delly_del_data[,4]))>=50 
                                    & as.numeric(as.character(Delly_del_data[,4]))<500,]
Delly_del_data_500 <- Delly_del_data[as.numeric(as.character(Delly_del_data[,4]))>=500,]
write.table(Delly_del_data,"Delly.deletion.bed",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")

Delly_ins_data <- vector()
for (i in 1:dim(Delly_ins)[1])
{
  item <- vector()
  # get length information from INFO column
  chromosome <- as.character(Delly_ins[i,1])
  position <- Delly_ins[i,2]
  Delly_inv_SV_start <- Delly_ins[i,2]
  Delly_inv_info <- strsplit(as.character(Delly_ins[i,8]),";")[[1]]
  
  Delly_inv_input_end <- Delly_inv_info[grep("INSLEN=",Delly_inv_info)][1]
  Delly_inv_SV_END <- as.numeric(substr(as.character(Delly_inv_input_end),8,nchar(Delly_inv_input_end)))
  
  Delly_inv_CIPOS <- Delly_inv_info[grep("CIPOS=",Delly_inv_info)][1]
  Delly_inv_SV_CIPOS <- as.numeric(substr(as.character(Delly_inv_CIPOS),8,gregexpr(pattern =',',Delly_inv_CIPOS)[[1]][1]-1))
  
  Delly_inv_CIEND <- Delly_inv_info[grep("CIEND=",Delly_inv_info)][1]
  Delly_inv_SV_CIEND <- as.numeric(substr(as.character(Delly_inv_CIEND),8,gregexpr(pattern =',',Delly_inv_CIEND)[[1]][1]-1))
  
  Delly_inv_SV_start1 <- Delly_inv_SV_start-Delly_inv_SV_CIPOS
  Delly_inv_SV_END2 <- Delly_inv_SV_start+Delly_inv_SV_END+Delly_inv_SV_CIEND
  
  item <- c(chromosome,Delly_inv_SV_start1,Delly_inv_SV_END2)
  Delly_ins_data <- rbind(Delly_ins_data,item)
}
Delly_length <- as.numeric(as.character(Delly_ins_data[,3]))-as.numeric(as.character(Delly_ins_data[,2]))
Delly_ins_data <- cbind(Delly_ins_data,Delly_length)
Delly_ins_data_50 <- Delly_ins_data[as.numeric(as.character(Delly_ins_data[,4]))>=50 
                                    & as.numeric(as.character(Delly_ins_data[,4]))<500,]
Delly_ins_data_500 <- Delly_ins_data[as.numeric(as.character(Delly_ins_data[,4]))>=500,]
#write.table(Delly_ins_data,"Delly.insertion.bed",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")

Delly_dup_data <- vector()
for (i in 1:dim(Delly_dup)[1])
{
  item <- vector()
  # get length information from INFO column
  chromosome <- as.character(Delly_del[i,1])
  position <- Delly_dup[i,2]
  Delly_dup_SV_start <- Delly_dup[i,2]
  Delly_dup_info <- strsplit(as.character(Delly_dup[i,8]),";")[[1]]
  
  Delly_dup_input_end <- Delly_dup_info[grep("END=",Delly_dup_info)][1]
  Delly_dup_SV_END <- as.numeric(substr(as.character(Delly_dup_input_end),5,nchar(Delly_dup_input_end)))
  
  Delly_dup_CIPOS <- Delly_dup_info[grep("CIPOS=",Delly_dup_info)][1]
  Delly_dup_SV_CIPOS <- as.numeric(substr(as.character(Delly_dup_CIPOS),8,gregexpr(pattern =',',Delly_dup_CIPOS)[[1]][1]-1))
  
  Delly_dup_CIEND <- Delly_dup_info[grep("CIEND=",Delly_dup_info)][1]
  Delly_dup_SV_CIEND <- as.numeric(substr(as.character(Delly_dup_CIEND),8,gregexpr(pattern =',',Delly_dup_CIEND)[[1]][1]-1))
  
  Delly_dup_SV_start1 <- Delly_dup_SV_start-Delly_dup_SV_CIPOS
  Delly_dup_SV_END2 <- Delly_dup_SV_END+Delly_dup_SV_CIEND
  
  item <- c(chromosome,Delly_dup_SV_start1,Delly_dup_SV_END2)
  Delly_dup_data <- rbind(Delly_dup_data,item)
}
Delly_length <- as.numeric(as.character(Delly_dup_data[,3]))-as.numeric(as.character(Delly_dup_data[,2]))
Delly_dup_data <- cbind(Delly_dup_data,Delly_length)

Delly_ins_combine_data <- data.frame(rbind(Delly_dup_data,Delly_ins_data))
Delly_ins_combine_data_50 <- Delly_ins_combine_data[as.numeric(as.character(Delly_ins_combine_data[,4]))>=50 
                                    & as.numeric(as.character(Delly_ins_combine_data[,4]))<500,]
Delly_ins_combine_data_500 <- Delly_ins_combine_data[as.numeric(as.character(Delly_ins_combine_data[,4]))>=500,]
Delly_ins_combine_data <- Delly_ins_combine_data[order(Delly_ins_combine_data$V1,as.numeric(Delly_ins_combine_data$V2)),]
#write.table(Delly_ins_combine_data,"Delly.insertion.combine.bed",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
















