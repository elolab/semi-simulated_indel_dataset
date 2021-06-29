VarScan <- read.table("varscan_indel.vcf")

VarScan_indel <- VarScan[nchar(as.character(VarScan[,4])) > 1 | nchar(as.character(VarScan[,5])) > 1,]
rownames(VarScan_indel) <- seq(length=nrow(VarScan_indel))# reset row name
VarScan_indel_del <- VarScan_indel[nchar(as.character(VarScan_indel[,4])) > 1,]
VarScan_indel_ins <- VarScan_indel[nchar(as.character(VarScan_indel[,5])) > 1,]
# make all indels together
VarScan_indel_ins1 <- vector()
VarScan_indel_del1 <- vector()
for (j in 1:dim(VarScan_indel_ins)[1])
{
  item <- vector()
  input_len <- nchar(as.character(VarScan_indel_ins[j,5]))-nchar(as.character(VarScan_indel_ins[j,4]))
  item_geno <- strsplit(as.character(VarScan_indel_ins[j,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(VarScan_indel_ins[j,2],input_len,item_geno)
  VarScan_indel_ins1 <- rbind(VarScan_indel_ins1,item)
}
for (j in 1:dim(VarScan_indel_del)[1])
{
  item <- vector()
  input_len <- nchar(as.character(VarScan_indel_del[j,4]))-nchar(as.character(VarScan_indel_del[j,5]))
  item_geno <- strsplit(as.character(VarScan_indel_del[j,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(VarScan_indel_del[j,2],input_len,item_geno)
  VarScan_indel_del1 <- rbind(VarScan_indel_del1,item)
}

VarScan_indel_del1 <- data.frame(VarScan_indel_del1)
VarScan_indel_ins1 <- data.frame(VarScan_indel_ins1)

truthset_ground <- read.table("variants_truthset.txt")
truthset_ground[truthset_ground[,5]=="1/0",5] <- "0/1"
truthset.deletion <- truthset_ground[truthset_ground[,1]=="deletion",]
truthset.insertion <- truthset_ground[truthset_ground[,1]=="insertion",]
parse_length <- function(P_input_get,truthset_get,category)
{
  P_input_get <- matrix(unlist(P_input_get), ncol = 3)
  
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
        P_input_LEN <- as.numeric(as.character(P_input_get[P_input_get[,1]==P-deviation,2]))
        P_input_GENO <- as.character(P_input_get[P_input_get[,1]==P-deviation,3])
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

parse_length(VarScan_indel_del1,truthset.deletion,"deletion")
parse_length(VarScan_indel_ins1,truthset.insertion,"insertion")






