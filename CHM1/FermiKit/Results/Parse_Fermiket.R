fermikit_sv <- read.table("fermikit.sv.vcf")
fermikit_sv <- fermikit_sv[as.numeric(as.character(fermikit_sv[,6]))>=5,]
chromosome_list <- c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13",
                     "chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX")
fermikit_sv <- fermikit_sv[fermikit_sv[,1] %in% chromosome_list,]
fermikit_sv <- fermikit_sv[fermikit_sv[,5]=="<DEL>" |fermikit_sv[,5]=="<INS>", ]
fermikit_sv_ins <- vector()
fermikit_sv_del <- vector()
for (i in 1: dim(fermikit_sv)[1])
{
  item <- vector()
  chromosome <- as.character(fermikit_sv[i,1])
  input_info <- strsplit(as.character(fermikit_sv[i,8]),";")[[1]]
  input_type <- input_info[grep("SVTYPE=",input_info)]
  input_len <- input_info[grep("SVLEN=",input_info)]
  input_LEN <- substr(as.character(input_len),7,nchar(input_len))
  input_END <- as.numeric(as.character(fermikit_sv[i,2]))+as.numeric(as.character(input_LEN))
  if (input_type == "SVTYPE=INS")
  {
    item <- c(chromosome,fermikit_sv[i,2],input_END,input_LEN)
    fermikit_sv_ins <- rbind(fermikit_sv_ins,item)  # first column is position, second column is SV length
  }
  else if (input_type == "SVTYPE=DEL")
  {
    item <- c(chromosome,fermikit_sv[i,2],input_END,input_LEN)
    fermikit_sv_del <- rbind(fermikit_sv_del,item)  # first column is position, second column is SV length
  }
}

fermikit_sv_del <- fermikit_sv_del[as.numeric(as.character(fermikit_sv_del[,4]))>=50,]
fermikit_sv_del <- fermikit_sv_del[,-4]
fermikit_sv_ins <- fermikit_sv_ins[as.numeric(as.character(fermikit_sv_ins[,4]))>=50,]
fermikit_sv_ins <- fermikit_sv_ins[,-4]

# get insertion and deletion from flt result
fermikit_flt <- read.table("fermikit.flt.vcf")
fermikit_flt_indel <- fermikit_flt[nchar(as.character(fermikit_flt[,4])) > 1 | nchar(as.character(fermikit_flt[,5])) > 1,]
fermikit_flt_indel <- fermikit_flt_indel[as.numeric(as.character(fermikit_flt_indel[,6]))>=5,]
fermikit_flt_indel <- fermikit_flt_indel[fermikit_flt_indel[,1] %in% chromosome_list,]
rownames(fermikit_flt_indel) <- seq(length=nrow(fermikit_flt_indel))# reset row name
fermikit_flt_ins <- fermikit_flt_indel[nchar(as.character(fermikit_flt_indel[,5]))-nchar(as.character(fermikit_flt_indel[,4]))>=50,]
fermikit_flt_del <- fermikit_flt_indel[nchar(as.character(fermikit_flt_indel[,4]))-nchar(as.character(fermikit_flt_indel[,5]))>=50,]
# make all indels together
fermikit_flt_ins1 <- vector()
fermikit_flt_del1 <- vector()
for (j in 1:dim(fermikit_flt_ins)[1])
{
  item <- vector()
  chromosome <- as.character(fermikit_flt_ins[j,1])
  input_len <- nchar(as.character(fermikit_flt_ins[j,5]))-1 # insertion length is column 5 
  item <- c(chromosome,fermikit_flt_ins[j,2],input_len)
  fermikit_flt_ins1 <- rbind(fermikit_flt_ins1,item)
}
fermikit_flt_ins1 <- fermikit_flt_ins1[as.numeric(as.character(fermikit_flt_ins1[,3]))>=50,]
end_coordinates_ins <- as.numeric(as.character(fermikit_flt_ins1[,2]))+ as.numeric(as.character(fermikit_flt_ins1[,3]))
fermikit_flt_ins2 <- cbind(fermikit_flt_ins1[,1],fermikit_flt_ins1[,2],end_coordinates_ins)
for (j in 1:dim(fermikit_flt_del)[1])
{
  item <- vector()
  chromosome <- as.character(fermikit_flt_del[j,1])
  input_len <- nchar(as.character(fermikit_flt_del[j,4]))-1 # deletion length is column 4 
  item <- c(chromosome,fermikit_flt_del[j,2],input_len)
  fermikit_flt_del1 <- rbind(fermikit_flt_del1,item)
}
fermikit_flt_del1 <- fermikit_flt_del1[as.numeric(as.character(fermikit_flt_del1[,3]))>=50,]
end_coordinates_del <- as.numeric(as.character(fermikit_flt_del1[,2]))+ as.numeric(as.character(fermikit_flt_del1[,3]))
fermikit_flt_del2 <- cbind(fermikit_flt_del1[,1],fermikit_flt_del1[,2],end_coordinates_del)

fermikit_sv_del <- rbind(fermikit_sv_del,fermikit_flt_del2)  
fermikit_sv_del <- fermikit_sv_del[order(fermikit_sv_del[,1]),]
fermikit_sv_ins <- rbind(fermikit_sv_ins,fermikit_flt_ins2) 
fermikit_sv_ins <- fermikit_sv_ins[order(fermikit_sv_ins[,1]),]


write.table(fermikit_sv_del,"FermiKit_deletion.bed",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
write.table(fermikit_sv_ins,"FermiKit_insertion.bed",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")


fermikit_length <- as.numeric(as.character(fermikit_sv_del[,3]))-as.numeric(as.character(fermikit_sv_del[,2]))
fermikit_sv_del <- cbind(fermikit_sv_del,fermikit_length)
fermikit_sv_del_50 <- fermikit_sv_del[as.numeric(as.character(fermikit_sv_del[,4]))>=50 
                                    & as.numeric(as.character(fermikit_sv_del[,4]))<500,]
fermikit_sv_del_1000 <- fermikit_sv_del[as.numeric(as.character(fermikit_sv_del[,4]))>=500,] 


fermikit_sv_ins <- read.table("FermiKit_insertion.bed")
fermikit_length <- as.numeric(as.character(fermikit_sv_ins[,3]))-as.numeric(as.character(fermikit_sv_ins[,2]))
fermikit_sv_ins <- cbind(fermikit_sv_ins,fermikit_length)
fermikit_sv_ins_50 <- fermikit_sv_ins[as.numeric(as.character(fermikit_sv_ins[,4]))>=50 
                                      & as.numeric(as.character(fermikit_sv_ins[,4]))<500,]
fermikit_sv_ins_1000 <- fermikit_sv_ins[as.numeric(as.character(fermikit_sv_ins[,4]))>=500,] 
                                   
















