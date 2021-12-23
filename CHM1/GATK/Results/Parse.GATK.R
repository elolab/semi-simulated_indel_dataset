GATK_input <- read.table("GATK_WGS.vcf")
chromosome_list <- c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13",
                     "chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX")
GATK_input <- GATK_input[GATK_input[,1] %in% chromosome_list,]

GATK_ins <- GATK_input[nchar(as.character(GATK_input[,4])) < nchar(as.character(GATK_input[,5])),]
GATK_del <- GATK_input[nchar(as.character(GATK_input[,4])) > nchar(as.character(GATK_input[,5])),]

#GATK_del <- GATK_del[GATK_del[,6]>200,]
GATK_del <- GATK_del[nchar(as.character(GATK_del[,4]))-nchar(as.character(GATK_del[,5]))>=50,]

#GATK_ins <- GATK_ins[GATK_ins[,6]>200,]
GATK_ins <- GATK_ins[nchar(as.character(GATK_ins[,5]))-nchar(as.character(GATK_ins[,4]))>=50,]


GATK_ins_data <- vector()
for (i in 1:dim(GATK_ins)[1])
{
  item <- vector()
  chromosome <- as.character(GATK_ins[i,1])
  position <- as.numeric(GATK_ins[i,2])#+nchar(as.character(Platypus_ins[i,5]))
  length <-  abs(nchar(as.character(GATK_ins[i,4])) - nchar(as.character(GATK_ins[i,5])))
  end <- position + length
  item <- c(chromosome,position,end)
  GATK_ins_data <- rbind(GATK_ins_data,item)
}
write.table(GATK_ins_data,"GATK_insertion.bed",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")

GATK_del_data <- vector()
for (i in 1:dim(GATK_del)[1])
{
  item <- vector()
  chromosome <- as.character(GATK_del[i,1])
  position <- as.numeric(GATK_del[i,2])#+nchar(as.character(Platypus_del[i,5]))
  length <-  abs(nchar(as.character(GATK_del[i,5])) - nchar(as.character(GATK_del[i,4])))
  end <- position + length
  item <- c(chromosome,position,end)
  GATK_del_data <- rbind(GATK_del_data,item)
}
write.table(GATK_del_data,"GATK_deletion.bed",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")


GATK_del_data <- read.table("GATK_deletion.bed")
GATK_length <- as.numeric(as.character(GATK_del_data[,3]))-as.numeric(as.character(GATK_del_data[,2]))
GATK_del_data <- cbind(GATK_del_data,GATK_length)
GATK_del_data_50 <- GATK_del_data[as.numeric(as.character(GATK_del_data[,4]))>=50 
                                    & as.numeric(as.character(GATK_del_data[,4]))<200,]
GATK_del_data_200 <- GATK_del_data[as.numeric(as.character(GATK_del_data[,4]))>=200 
                                  & as.numeric(as.character(GATK_del_data[,4]))<500,]
GATK_del_data_1000 <- GATK_del_data[as.numeric(as.character(GATK_del_data[,4]))>=500 
                                      & as.numeric(as.character(GATK_del_data[,4]))<10000,]

GATK_ins_data <- read.table("GATK_insertion.bed")
GATK_length <- as.numeric(as.character(GATK_ins_data[,3]))-as.numeric(as.character(GATK_ins_data[,2]))
GATK_ins_data <- cbind(GATK_ins_data,GATK_length)
GATK_ins_data_50 <- GATK_ins_data[as.numeric(as.character(GATK_ins_data[,4]))>=50 
                                          & as.numeric(as.character(GATK_ins_data[,4]))<200,]
GATK_ins_data_200 <- GATK_ins_data[as.numeric(as.character(GATK_ins_data[,4]))>=200 
                                  & as.numeric(as.character(GATK_ins_data[,4]))<500,]
GATK_ins_data_1000 <- GATK_ins_data[as.numeric(as.character(GATK_ins_data[,4]))>=500 
                                            & as.numeric(as.character(GATK_ins_data[,4]))<10000,]


















