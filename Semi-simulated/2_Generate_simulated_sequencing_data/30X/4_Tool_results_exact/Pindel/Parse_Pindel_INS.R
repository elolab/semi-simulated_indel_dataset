SIe5 <- read.table("Pindel_simulatedD_SI.vcf")

Pindel_ins_data <- vector()
for (i in 1:dim(SIe5)[1])
{
  item <- vector()
  # get length information from INFO column
  position <- SIe5[i,2]
  Pindel_ins_info<- strsplit(as.character(SIe5[i,8]),";")[[1]]
  Pindel_ins_len <- Pindel_ins_info[grep("SVLEN=",Pindel_ins_info)]
  Pindel_ins_LEN <- substr(as.character(Pindel_ins_len),7,nchar(Pindel_ins_len))
  geno <- strsplit(as.character(SIe5[i,10]),":")[[1]][1]
  if (geno=="1/0")
  {
    geno <- "0/1"
  }
  item <- c(position,Pindel_ins_LEN,geno)
  Pindel_ins_data <- rbind(Pindel_ins_data,item)
}
Pindel_ins_data <- data.frame(Pindel_ins_data)

truthset_ground <- read.table("variants_truthset.txt")
truthset_ground[truthset_ground[,5]=="1/0",5] <- "0/1"
truthset.deletion <- truthset_ground[truthset_ground[,1]=="deletion",]
truthset.insertion <- truthset_ground[truthset_ground[,1]=="insertion",]
parse_length <- function(P_input_get,truthset_get,category)
{
  P_input_get <- matrix(unlist(P_input_get), ncol = 3) #as.numeric(as.character(P_input[,1]))
  
  # get positions
  position_in <- as.numeric(as.character(P_input_get[,1]))
  position_truth <- as.numeric(as.character(truthset_get[,2]))
  
  #TP matrix
  TP_matrix <- vector()
  # calculated results  
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
        P_input_LEN <- as.numeric(as.character(P_input_get[P_input_get[,1]==P-deviation,2]))[1]
        P_input_GENO <- as.character(P_input_get[P_input_get[,1]==P-deviation,3])[1]
        truth_length <- as.numeric(as.character(truthset_get[as.numeric(as.character(truthset_get[,2]))==P,3]))
        truth_GENO <- as.character(truthset_get[as.numeric(as.character(truthset_get[,2]))==P,5])
        # length deviation 20% of truth upper
        if (abs(truth_length-abs(as.numeric(P_input_LEN))) <= as.numeric(truth_length)*0.25)
        {
          # remove match position, avoid getting repeat results, due to one indel maybe report twice near by the break point
          position_truth <- position_truth[!(position_truth %in% P)] 
          position_in <- position_in[!(position_in %in% (P-deviation))]
          TP_item <- c(as.numeric(P-deviation),P_input_LEN,P_input_GENO,as.numeric(P),truth_length,truth_GENO)
          TP_matrix <- rbind(TP_matrix,TP_item)
        }
      }
    }
  }
  file_name <- paste0(as.character(category),".txt")
  write.table(TP_matrix,file_name,row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
}

parse_length(Pindel_ins_data,truthset.insertion,"insertion")













