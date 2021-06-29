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

DeepVariant_sv <- read.table("deepvariants.recode.vcf")
DeepVariant_sv <- rbind(DeepVariant_sv,Split_allele)
DeepVariant_sv <- DeepVariant_sv[order(as.numeric(DeepVariant_sv[,2])),]

DeepVariant_ins <- DeepVariant_sv[nchar(as.character(DeepVariant_sv[,5]))-nchar(as.character(DeepVariant_sv[,4]))>=1,]
DeepVariant_del <- DeepVariant_sv[nchar(as.character(DeepVariant_sv[,4]))-nchar(as.character(DeepVariant_sv[,5]))>=1,]

DeepVariant_ins1 <- vector()
DeepVariant_del1 <- vector()
for (j in 1:dim(DeepVariant_ins)[1])
{
  item <- vector()
  input_len <- nchar(as.character(DeepVariant_ins[j,5]))-nchar(as.character(DeepVariant_ins[j,4])) # insertion length is column 5 
  item_geno <- strsplit(as.character(DeepVariant_ins[j,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(DeepVariant_ins[j,2],input_len,item_geno)
  DeepVariant_ins1 <- rbind(DeepVariant_ins1,item)
}
for (j in 1:dim(DeepVariant_del)[1])
{
  item <- vector()
  input_len <- nchar(as.character(DeepVariant_del[j,4]))-nchar(as.character(DeepVariant_del[j,5])) # deletion length is column 4 
  item_geno <- strsplit(as.character(DeepVariant_del[j,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(DeepVariant_del[j,2],input_len,item_geno)
  DeepVariant_del1 <- rbind(DeepVariant_del1,item)
}
DeepVariant_del1 <- data.frame(DeepVariant_del1)
DeepVariant_ins1 <- data.frame(DeepVariant_ins1)

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
        print (P_input_LEN)
        P_input_GENO <- as.character(P_input_get[P_input_get[,1]==P-deviation,3])
        truth_length <- as.numeric(as.character(truthset_get[as.numeric(as.character(truthset_get[,2]))==P,3]))
        truth_GENO <- as.character(truthset_get[as.numeric(as.character(truthset_get[,2]))==P,5])
        # length deviation 20% of truth upper
        for (k in 1:length(P_input_LEN))
        {
          if (abs(truth_length-abs(as.numeric(P_input_LEN[k]))) <= as.numeric(truth_length)*0.25)
          {
            # remove match position, avoid getting repeat results, due to one indel maybe report twice near by the break point
            position_truth <- position_truth[!(position_truth %in% P)] 
            position_in <- position_in[!(position_in %in% (P-deviation))]
            TP_item <- c(as.numeric(P-deviation),P_input_LEN[k],P_input_GENO[k],as.numeric(P),truth_length,truth_GENO)
            TP_matrix <- rbind(TP_matrix,TP_item)
          } 
        }
      }
    }
  }
  file_name <- paste0(as.character(category),".txt")
  write.table(TP_matrix,file_name,row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
}

parse_length(DeepVariant_del1,truthset.deletion,"deletion")
parse_length(DeepVariant_ins1,truthset.insertion,"insertion")


























































