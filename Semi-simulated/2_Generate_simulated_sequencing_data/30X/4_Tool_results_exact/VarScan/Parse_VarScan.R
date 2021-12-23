VarScan_pre <- read.table("varscan_indel.vcf")
chr_pick <- c("chr1","chr2")
VarScan_indel_del1_all <- vector()
VarScan_indel_ins1_all <- vector()
for (chr in chr_pick)
{
  VarScan <- VarScan_pre[VarScan_pre[,1]==chr,]
  
  VarScan_indel_del <- VarScan[nchar(as.character(VarScan[,4]))-nchar(as.character(VarScan[,5])) >= 1,]
  VarScan_indel_ins <- VarScan[nchar(as.character(VarScan[,5]))-nchar(as.character(VarScan[,4])) >= 1,]

  VarScan_indel_ins1 <- vector()
  VarScan_indel_del1 <- vector()
  for (j in 1:dim(VarScan_indel_ins)[1])
  {
    item <- vector()
    input_len <- nchar(as.character(VarScan_indel_ins[j,5]))-nchar(as.character(VarScan_indel_ins[j,4]))
    item_geno <- strsplit(as.character(VarScan_indel_ins[j,10]),":")[[1]][1]
    item <- c(chr,VarScan_indel_ins[j,2],input_len,item_geno)
    VarScan_indel_ins1 <- rbind(VarScan_indel_ins1,item)
  }
  for (j in 1:dim(VarScan_indel_del)[1])
  {
    item <- vector()
    input_len <- nchar(as.character(VarScan_indel_del[j,4]))-nchar(as.character(VarScan_indel_del[j,5]))
    item_geno <- strsplit(as.character(VarScan_indel_del[j,10]),":")[[1]][1]
    item <- c(chr,VarScan_indel_del[j,2],input_len,item_geno)
    VarScan_indel_del1 <- rbind(VarScan_indel_del1,item)
  }
  
  VarScan_indel_del1 <- data.frame(VarScan_indel_del1)
  VarScan_indel_ins1 <- data.frame(VarScan_indel_ins1)
  VarScan_indel_del1_all <- rbind(VarScan_indel_del1_all,VarScan_indel_del1)
  VarScan_indel_ins1_all <- rbind(VarScan_indel_ins1_all,VarScan_indel_ins1)
}

truthset_ground <- read.table("chr1_chr2_variants_truthset.txt")
truthset_ground[truthset_ground[,5]=="1/0",5] <- "0/1"
truthset.deletion <- truthset_ground[truthset_ground[,1]=="deletion",]
truthset.insertion <- truthset_ground[truthset_ground[,1]=="insertion",]
parse_length <- function(P_input_get,truthset_get,category)
{
  P_input_get <- matrix(unlist(P_input_get), ncol = 4) 
  chr_pick2 <- c("chr1","chr2")
  
  TP_matrix <- vector()
  for (chr_select in chr_pick2)
  {
    P_input_get_chr <- P_input_get[P_input_get[,1]==chr_select,]
    truthset_get_chr <- truthset_get[truthset_get[,7]==chr_select,]

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
              TP_item <- c(chr_select,as.numeric(P-deviation),P_input_LEN[k],P_input_GENO[k],chr_select,as.numeric(P),truth_length,truth_GENO)
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

parse_length(VarScan_indel_del1_all,truthset.deletion,"deletion")
parse_length(VarScan_indel_ins1_all,truthset.insertion,"insertion")
