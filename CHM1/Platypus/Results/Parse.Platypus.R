Platypus_input <- read.table("out.recode.vcf")
chromosome_list <- c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13",
                     "chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX")
Platypus_input <- Platypus_input[Platypus_input[,1] %in% chromosome_list,]

Platypus_ins <- Platypus_input[nchar(as.character(Platypus_input[,4])) < nchar(as.character(Platypus_input[,5])),]
Platypus_del <- Platypus_input[nchar(as.character(Platypus_input[,4])) > nchar(as.character(Platypus_input[,5])),]

Platypus_del <- Platypus_del[Platypus_del[,7]=="PASS",]
Platypus_del <- Platypus_del[nchar(as.character(Platypus_del[,4]))-nchar(as.character(Platypus_del[,5]))>=50,]

Platypus_ins <- Platypus_ins[Platypus_ins[,7]=="PASS",]
Platypus_ins <- Platypus_ins[nchar(as.character(Platypus_ins[,5]))-nchar(as.character(Platypus_ins[,4]))>=50,]


Platypus_ins_data <- vector()
for (i in 1:dim(Platypus_ins)[1])
{
  item <- vector()
  chromosome <- as.character(Platypus_ins[i,1])
  position <- as.numeric(Platypus_ins[i,2])#+nchar(as.character(Platypus_ins[i,5]))
  length <-  abs(nchar(as.character(Platypus_ins[i,4])) - nchar(as.character(Platypus_ins[i,5])))
  end <- position + length
  item <- c(chromosome,position,end)
  Platypus_ins_data <- rbind(Platypus_ins_data,item)
}
write.table(Platypus_ins_data,"Platypus_insertion.bed",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")

Platypus_del_data <- vector()
for (i in 1:dim(Platypus_del)[1])
{
  item <- vector()
  chromosome <- as.character(Platypus_del[i,1])
  position <- as.numeric(Platypus_del[i,2])#+nchar(as.character(Platypus_del[i,5]))
  length <-  abs(nchar(as.character(Platypus_del[i,5])) - nchar(as.character(Platypus_del[i,4])))
  end <- position + length
  item <- c(chromosome,position,end)
  Platypus_del_data <- rbind(Platypus_del_data,item)
}
write.table(Platypus_del_data,"Platypus_deletion.bed",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")


Platypus_del_data <- read.table("Platypus_deletion.bed")
Platypus_length <- as.numeric(as.character(Platypus_del_data[,3]))-as.numeric(as.character(Platypus_del_data[,2]))
Platypus_del_data <- cbind(Platypus_del_data,Platypus_length)
Platypus_del_data_50 <- Platypus_del_data[as.numeric(as.character(Platypus_del_data[,4]))>=50 
                                    & as.numeric(as.character(Platypus_del_data[,4]))<500,]
Platypus_del_data_1000 <- Platypus_del_data[as.numeric(as.character(Platypus_del_data[,4]))>=500,] 
                             
Platypus_ins_data <- read.table("Platypus_insertion.bed")
Platypus_length <- as.numeric(as.character(Platypus_ins_data[,3]))-as.numeric(as.character(Platypus_ins_data[,2]))
Platypus_ins_data <- cbind(Platypus_ins_data,Platypus_length)
Platypus_ins_data_50 <- Platypus_ins_data[as.numeric(as.character(Platypus_ins_data[,4]))>=50 
                                          & as.numeric(as.character(Platypus_ins_data[,4]))<500,]
Platypus_ins_data_1000 <- Platypus_ins_data[as.numeric(as.character(Platypus_ins_data[,4]))>=500,] 



















