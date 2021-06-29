fermikit_sv <- read.table("fermikit.sv.vcf")
# FermiKit only has 3 SVTYPE: INS,DEL,COMPLEX
fermikit_sv_ins <- vector()
fermikit_sv_del <- vector()
fermikit_sv_cpx <- vector()
# split indels from SV result
# summary(as.numeric(fermikit_sv_ins[,2])), min_length is 104
# summary(as.numeric(fermikit_sv_del[,2])), min_length is 88
for (i in 1: dim(fermikit_sv)[1])
{
  item <- vector()
  input_info <- strsplit(as.character(fermikit_sv[i,8]),";")[[1]]
  input_type <- input_info[grep("SVTYPE=",input_info)]
  input_len <- input_info[grep("SVLEN=",input_info)]
  input_LEN <- substr(as.character(input_len),7,nchar(input_len))
  if (input_type == "SVTYPE=INS")
  {
    item <- c(fermikit_sv[i,2],input_LEN,"0/0")
    fermikit_sv_ins <- rbind(fermikit_sv_ins,item)  # first column is position, second column is SV length
  }
  else if (input_type == "SVTYPE=DEL")
  {
    item <- c(fermikit_sv[i,2],input_LEN,"0/0")
    fermikit_sv_del <- rbind(fermikit_sv_del,item)  # first column is position, second column is SV length
  }
  else if (input_type == "SVTYPE=COMPLEX")
  {
    item <- c(fermikit_sv[i,2],input_LEN)
    fermikit_sv_cpx <- rbind(fermikit_sv_cpx,item)  # first column is position, second column is SV length
  }
}

# get insertion and deletion from flt result
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

fermikit_flt <- read.table("fermikit.flt.recode.vcf")
fermikit_flt <- rbind(fermikit_flt,Split_allele)
fermikit_flt <- fermikit_flt[order(as.numeric(fermikit_flt[,2])),]

fermikit_flt_indel <- fermikit_flt[nchar(as.character(fermikit_flt[,4])) > 1 | nchar(as.character(fermikit_flt[,5])) > 1,]
rownames(fermikit_flt_indel) <- seq(length=nrow(fermikit_flt_indel))# reset row name
fermikit_flt_ins <- fermikit_flt_indel[nchar(as.character(fermikit_flt_indel[,5]))-nchar(as.character(fermikit_flt_indel[,4]))>=1,]
fermikit_flt_del <- fermikit_flt_indel[nchar(as.character(fermikit_flt_indel[,4]))-nchar(as.character(fermikit_flt_indel[,5]))>=1,]
# make all indels together
fermikit_flt_ins1 <- vector()
fermikit_flt_del1 <- vector()
for (j in 1:dim(fermikit_flt_ins)[1])
{
  item <- vector()
  input_len <- nchar(as.character(fermikit_flt_ins[j,5]))-nchar(as.character(fermikit_flt_ins[j,4])) # insertion length is column 5 
  item_geno <- strsplit(as.character(fermikit_flt_ins[j,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(fermikit_flt_ins[j,2],input_len,item_geno)
  fermikit_flt_ins1 <- rbind(fermikit_flt_ins1,item)
  fermikit_sv_ins <- rbind(fermikit_sv_ins,item)  
}
for (j in 1:dim(fermikit_flt_del)[1])
{
  item <- vector()
  input_len <- nchar(as.character(fermikit_flt_del[j,4]))-nchar(as.character(fermikit_flt_del[j,5])) # deletion length is column 4 
  item_geno <- strsplit(as.character(fermikit_flt_del[j,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(fermikit_flt_del[j,2],input_len,item_geno)
  fermikit_flt_del1 <- rbind(fermikit_flt_del1,item)
  fermikit_sv_del <- rbind(fermikit_sv_del,item)  
}

# summary(fermikit_flt_del1[,2]) max_length:197
# summary(fermikit_flt_ins1[,2]) max_length:200

# make matrix into dataframe and sort it by position
rownames(fermikit_sv_del) <- seq(length=nrow(fermikit_sv_del))
fermikit_sv_del <- data.frame(fermikit_sv_del)
fermikit_sv_del <- fermikit_sv_del[order(fermikit_sv_del$X1),]
rownames(fermikit_sv_del) <- seq(length=nrow(fermikit_sv_del))
rownames(fermikit_sv_ins) <- seq(length=nrow(fermikit_sv_ins))
fermikit_sv_ins <- data.frame(fermikit_sv_ins)
fermikit_sv_ins <- fermikit_sv_ins[order(fermikit_sv_ins$X1),]
rownames(fermikit_sv_ins) <- seq(length=nrow(fermikit_sv_ins))
fermikit_sv_del <- data.frame(fermikit_sv_del)
fermikit_sv_ins <- data.frame(fermikit_sv_ins)

write.table(fermikit_sv_del,"deletion_result.txt",row.names = F,col.names = F,quote = F)
write.table(fermikit_sv_ins,"insertion_result.txt",row.names = F,col.names = F,quote = F)







