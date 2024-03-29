SIe5_pre <- read.table("Pindel_simulatedD_SI.vcf")
Pindel_ins_data_all <- vector()
chr_pick <- c("chr1","chr2")
for (chr in chr_pick)
{
  SIe5 <- SIe5_pre[SIe5_pre[,1]==chr,]
  Pindel_ins_data <- vector()
  
  for (i in 1:dim(SIe5)[1])
  {
    item <- vector()
    position <- SIe5[i,2]
    Pindel_ins_info<- strsplit(as.character(SIe5[i,8]),";")[[1]]
    Pindel_ins_len <- Pindel_ins_info[grep("SVLEN=",Pindel_ins_info)]
    Pindel_ins_LEN <- substr(as.character(Pindel_ins_len),7,nchar(Pindel_ins_len))
    geno <- strsplit(as.character(SIe5[i,10]),":")[[1]][1]
    item <- c(chr,position,Pindel_ins_LEN,geno)
    Pindel_ins_data <- rbind(Pindel_ins_data,item)
  }
  Pindel_ins_data <- data.frame(Pindel_ins_data)
  Pindel_ins_data_all <- rbind(Pindel_ins_data_all,Pindel_ins_data)
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

parse_length(Pindel_ins_data_all,truthset.insertion,"insertion")
