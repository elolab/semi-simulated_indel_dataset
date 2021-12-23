# split into subsets
Pindel_del_data_all <- vector()
Pindel_del_pre <- read.table("Pindel_simulatedD_D.vcf")
chr_pick <- c("chr1","chr2")
for (chr in chr_pick)
{
  Pindel_del_data <- vector()
  Pindel_del <- Pindel_del_pre[Pindel_del_pre[,1]==chr,]
  for (i in 1:dim(Pindel_del)[1])
  {
    item <- vector()
    # get length information from INFO column
    position <- Pindel_del[i,2]
    Pindel_del_info<- strsplit(as.character(Pindel_del[i,8]),";")[[1]]
    Pindel_del_len <- Pindel_del_info[grep("SVLEN=",Pindel_del_info)]
    Pindel_del_LEN <- substr(as.character(Pindel_del_len),8,nchar(Pindel_del_len)) # move "-" out'
    geno <- strsplit(as.character(Pindel_del[i,10]),":")[[1]][1]
    item <- c(chr,position,Pindel_del_LEN,geno)
    Pindel_del_data <- rbind(Pindel_del_data,item)
  }
  Pindel_del_data <- data.frame(Pindel_del_data)
  Pindel_del_data_all <- rbind(Pindel_del_data_all,Pindel_del_data)
}

truthset_ground <- read.table("/data/epouta1/B18010_indel_tool_evaluation/Semi-simulated_chr2/Other_tools/chr1_chr2_variants_truthset.txt")
truthset_ground[truthset_ground[,5]=="1/0",5] <- "0/1"
truthset.deletion <- truthset_ground[truthset_ground[,1]=="deletion",]
truthset.insertion <- truthset_ground[truthset_ground[,1]=="insertion",]
parse_length <- function(P_input_get,truthset_get,category)
{
  P_input_get <- matrix(unlist(P_input_get), ncol = 4) #as.numeric(as.character(P_input[,1]))
  chr_pick <- c("chr1","chr2")
  
  #TP matrix
  TP_matrix <- vector()
  for (chr in chr_pick)
  {
    P_input_get_chr <- P_input_get[P_input_get[,1]==chr,]
    truthset_get_chr <- truthset_get[truthset_get[,7]==chr,]
    # get positions
    position_in <- as.numeric(as.character(P_input_get_chr[,2]))
    position_truth <- as.numeric(as.character(truthset_get_chr[,2]))
    
    # calculated results  
    for (j in 0:50) # position tolerate??????????
      #for (j in -as.integer(as.numeric(interval_2[i])*0.8):as.integer(as.numeric(interval_2[i])*0.8))
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
          # length deviation 20% of truth upper
          for (k in 1:length(P_input_LEN))
          {
            if (abs(truth_length-abs(as.numeric(P_input_LEN[k]))) <= as.numeric(truth_length)*0.25)
              # as.numeric(as.character(truthset[as.numeric(as.character(truthset[,2]))==P,3]))*0.2  # length tolerate
              #& truth_GENO==P_input_GENO) # genotype correction can be access later
            {
              # remove match position, avoid getting repeat results, due to one indel maybe report twice near by the break point
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

parse_length(Pindel_del_data_all,truthset.deletion,"deletion")
