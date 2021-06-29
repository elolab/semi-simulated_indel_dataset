Delly_input <- read.table("delly_default.vcf")
Delly_del <- vector()
Delly_ins <- vector()
Delly_dup <- vector()
# type <- vector()
for (i in 1:dim(Delly_input)[1])
{
  Delly_input_info <- strsplit(as.character(Delly_input[i,8]),";")[[1]]
  Delly_input_type <- Delly_input_info[grep("SVTYPE=",Delly_input_info)]
  Delly_input_TYPE <- substr(as.character(Delly_input_type),8,nchar(Delly_input_type))
  # type <- c(type,Delly_input_TYPE) contain "DEL" "DUP" "INS" "INV"
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

Delly_del_data <- vector()
for (i in 1:dim(Delly_del)[1])
{
  item <- vector()
  # get length information from INFO column
  position <- Delly_del[i,2]
  Delly_del_SV_start <- Delly_del[i,2]
  Delly_del_info <- strsplit(as.character(Delly_del[i,8]),";")[[1]]
  Delly_del_input_end <- Delly_del_info[grep("END=",Delly_del_info)][1]
  Delly_del_SV_END <- as.numeric(substr(as.character(Delly_del_input_end),5,nchar(Delly_del_input_end)))
  Delly_del_input_LEN <- Delly_del_SV_END-Delly_del_SV_start
  item_geno <- strsplit(as.character(Delly_del[i,10]),":")[[1]][1]
  item <- c(position,Delly_del_input_LEN,item_geno)
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  Delly_del_data <- rbind(Delly_del_data,item)
}
Delly_del_data <- data.frame(Delly_del_data)

# Delly insertion have INSLEN in VCF format column
# While deletion and duplication INSLEN are all 0, length can only calculate by END-position
if (dim(Delly_ins)[1]!=0)
{
  Delly_ins_data <- vector()
  for (i in 1:dim(Delly_ins)[1])
  {
    item <- vector()
    # get length information from INFO column
    position <- Delly_ins[i,2]
    Delly_ins_SV_start <- Delly_ins[i,2]
    Delly_ins_info <- strsplit(as.character(Delly_ins[i,8]),";")[[1]]
    Delly_ins_input_len <- Delly_ins_info[grep("INSLEN=",Delly_ins_info)][1]
    Delly_ins_input_LEN <- as.numeric(substr(as.character(Delly_ins_input_len),8,nchar(Delly_ins_input_len)))
    item_geno <- strsplit(as.character(Delly_ins[i,10]),":")[[1]][1]
    if (item_geno=="1/0")
    {
      item_geno <- "0/1"
    }
    item <- c(position,Delly_ins_input_LEN,item_geno)
    Delly_ins_data <- rbind(Delly_ins_data,item)
  }
  Delly_ins_data <- data.frame(Delly_ins_data)
}

Delly_dup_data <- vector()
for (i in 1:dim(Delly_dup)[1])
{
  item <- vector()
  # get length information from INFO column
  position <- Delly_dup[i,2]
  Delly_dup_SV_start <- Delly_dup[i,2]
  Delly_dup_info <- strsplit(as.character(Delly_dup[i,8]),";")[[1]]
  Delly_dup_input_end <- Delly_dup_info[grep("END=",Delly_dup_info)][1]
  Delly_dup_SV_END <- as.numeric(substr(as.character(Delly_dup_input_end),5,nchar(Delly_dup_input_end)))
  Delly_dup_input_LEN <- Delly_dup_SV_END-Delly_dup_SV_start
  item_geno <- strsplit(as.character(Delly_dup[i,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(position,Delly_dup_input_LEN,item_geno)
  Delly_dup_data <- rbind(Delly_dup_data,item)
}
Delly_dup_data <- data.frame(Delly_dup_data)
Delly_ins_data <- rbind(Delly_ins_data,Delly_dup_data)
write.table(Delly_del_data,"deletion_result.txt",row.names = F,col.names = F,quote = F)
write.table(Delly_ins_data,"insertion_result.txt",row.names = F,col.names = F,quote = F)








