Delly_input <- read.table("delly_default.vcf")
Delly_del <- vector()
Delly_ins <- vector()
Delly_dup <- vector()
for (i in 1:dim(Delly_input)[1])
{
  Delly_input_info <- strsplit(as.character(Delly_input[i,8]),";")[[1]]
  Delly_input_type <- Delly_input_info[grep("SVTYPE=",Delly_input_info)]
  Delly_input_TYPE <- substr(as.character(Delly_input_type),8,nchar(Delly_input_type))
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

truthset_ground <- read.table("chr1_chr2_variants_truthset.txt")
truthset_ground[truthset_ground[,5]=="1/0",5] <- "0/1"
truthset.deletion <- truthset_ground[truthset_ground[,1]=="deletion",]
truthset.insertion <- truthset_ground[truthset_ground[,1]=="insertion",]
parse_length <- function(P_input_get,truthset_get,category)
{
  P_input_get <- matrix(unlist(P_input_get), ncol = 4)
  chr_pick <- c("chr1","chr2")
  TP_matrix <- vector()
  for (chr in chr_pick)
  {
    P_input_get_chr <- P_input_get[P_input_get[,1]==chr,]
    truthset_get_chr <- truthset_get[truthset_get[,7]==chr,]

    position_in <- as.numeric(as.character(P_input_get_chr[,2]))
    position_truth <- as.numeric(as.character(truthset_get_chr[,2]))
    
    for (j in 0:50) 
    {
      wave <- c(-1,1)
      for (w in wave)
      {
        deviation <- j*w
        TP_sub <- intersect(as.numeric(position_in)+deviation,position_truth)
        for (P in TP_sub)
        {
          TP_item <- vector()
          P_input_LEN <- as.numeric(as.character(P_input_get_chr[P_input_get_chr[,2]==P-deviation,3]))
          P_input_GENO <- as.character(P_input_get_chr[P_input_get_chr[,2]==P-deviation,4])
          truth_length <- as.numeric(as.character(truthset_get_chr[as.numeric(as.character(truthset_get_chr[,2]))==P,3]))
          truth_GENO <- as.character(truthset_get_chr[as.numeric(as.character(truthset_get_chr[,2]))==P,5])
          for (k in 1:length(P_input_LEN))
          {
            if (abs(truth_length-abs(as.numeric(P_input_LEN[k]))) <= as.numeric(truth_length)*0.25)
            {
              position_truth <- position_truth[!(position_truth %in% P)] 
              position_in <- position_in[!(position_in %in% (P-deviation))]
              TP_item <- c(chr,as.numeric(P-deviation),P_input_LEN[k],P_input_GENO[k],chr,as.numeric(P),truth_length,truth_GENO)
              TP_matrix <- rbind(TP_matrix,TP_item)
            } 
          }
        }
      }
    }
  }
  file_name <- paste0(as.character(category),".txt")
  write.table(TP_matrix,file_name,row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
}

Delly_del_data <- vector()
for (i in 1:dim(Delly_del)[1])
{
  item <- vector()
  chromosome <- Delly_del[i,1]
  position <- Delly_del[i,2]
  Delly_del_SV_start <- Delly_del[i,2]
  Delly_del_info <- strsplit(as.character(Delly_del[i,8]),";")[[1]]
  Delly_del_input_end <- Delly_del_info[grep("END=",Delly_del_info)][1]
  Delly_del_SV_END <- as.numeric(substr(as.character(Delly_del_input_end),5,nchar(Delly_del_input_end)))
  Delly_del_input_LEN <- Delly_del_SV_END-Delly_del_SV_start-1
  item_geno <- strsplit(as.character(Delly_del[i,10]),":")[[1]][1]
  item <- c(chromosome,position,Delly_del_input_LEN,item_geno)
  Delly_del_data <- rbind(Delly_del_data,item)
}
Delly_del_data <- data.frame(Delly_del_data)
parse_length(Delly_del_data,truthset.deletion,"deletion")

if (dim(Delly_ins)[1]!=0)
{
  Delly_ins_data <- vector()
  for (i in 1:dim(Delly_ins)[1])
  {
    item <- vector()
    chromosome <- Delly_ins[i,1]

    position <- Delly_ins[i,2]
    Delly_ins_SV_start <- Delly_ins[i,2]
    Delly_ins_info <- strsplit(as.character(Delly_ins[i,8]),";")[[1]]
    Delly_ins_input_len <- Delly_ins_info[grep("INSLEN=",Delly_ins_info)][1]
    Delly_ins_input_LEN <- as.numeric(substr(as.character(Delly_ins_input_len),8,nchar(Delly_ins_input_len)))
    item_geno <- strsplit(as.character(Delly_ins[i,10]),":")[[1]][1]
    item <- c(chromosome,position,Delly_ins_input_LEN,item_geno)
    Delly_ins_data <- rbind(Delly_ins_data,item)
  }
  Delly_ins_data <- data.frame(Delly_ins_data)
  parse_length(Delly_ins_data,truthset.insertion,"insertion1")
}

Delly_dup_data <- vector()
for (i in 1:dim(Delly_dup)[1])
{
  item <- vector()
  chromosome <- Delly_dup[i,1]
  position <- Delly_dup[i,2]
  Delly_dup_SV_start <- Delly_dup[i,2]
  Delly_dup_info <- strsplit(as.character(Delly_dup[i,8]),";")[[1]]
  Delly_dup_input_end <- Delly_dup_info[grep("END=",Delly_dup_info)][1]
  Delly_dup_SV_END <- as.numeric(substr(as.character(Delly_dup_input_end),5,nchar(Delly_dup_input_end)))
  Delly_dup_input_LEN <- Delly_dup_SV_END-Delly_dup_SV_start
  item_geno <- strsplit(as.character(Delly_dup[i,10]),":")[[1]][1]
  item <- c(chromosome,position,Delly_dup_input_LEN,item_geno)
  Delly_dup_data <- rbind(Delly_dup_data,item)
}
Delly_dup_data <- data.frame(Delly_dup_data)
parse_length(Delly_dup_data,truthset.insertion,"duplication1")

