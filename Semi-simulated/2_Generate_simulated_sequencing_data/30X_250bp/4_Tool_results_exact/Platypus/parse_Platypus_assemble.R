raw_input <- read.table("out3.recode.vcf")

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

Platypus_input <- read.table("assembel.indel.recode.vcf")
Platypus_input <- rbind(Platypus_input,Split_allele)
Platypus_input <- Platypus_input[order(as.numeric(Platypus_input[,2])),]

Platypus_ins <- Platypus_input[nchar(as.character(Platypus_input[,5]))-nchar(as.character(Platypus_input[,4]))>=1,]
Platypus_del <- Platypus_input[nchar(as.character(Platypus_input[,4]))-nchar(as.character(Platypus_input[,5]))>=1,]
what <- Platypus_input[nchar(as.character(Platypus_input[,4])) == nchar(as.character(Platypus_input[,5])),]
# get some SNV, which can be false positive

Platypus_ins_data <- vector()
for (i in 1:dim(Platypus_ins)[1])
{
  item <- vector()
  position <- as.numeric(Platypus_ins[i,2])#+nchar(as.character(Platypus_ins[i,5]))
  length <-  abs(nchar(as.character(Platypus_ins[i,4])) - nchar(as.character(Platypus_ins[i,5])))
  item_geno <- strsplit(as.character(Platypus_ins[i,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(position,length,item_geno)
  Platypus_ins_data <- rbind(Platypus_ins_data,item)
}

Platypus_del_data <- vector()
for (i in 1:dim(Platypus_del)[1])
{
  item <- vector()
  position <- as.numeric(Platypus_del[i,2])#+nchar(as.character(Platypus_del[i,5]))
  length <-  abs(nchar(as.character(Platypus_del[i,4])) - nchar(as.character(Platypus_del[i,5])))
  item_geno <- strsplit(as.character(Platypus_del[i,10]),":")[[1]][1]
  if (item_geno=="1/0")
  {
    item_geno <- "0/1"
  }
  item <- c(position,length,item_geno)
  Platypus_del_data <- rbind(Platypus_del_data,item)
}

Platypus_del_data <- data.frame(Platypus_del_data)
Platypus_ins_data <- data.frame(Platypus_ins_data)

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
        P_input_LEN <- as.numeric(as.character(P_input_get[P_input_get[,1]==P-deviation,2]))
        print (P_input_LEN)
        P_input_GENO <- as.character(P_input_get[P_input_get[,1]==P-deviation,3])
        truth_length <- as.numeric(as.character(truthset_get[as.numeric(as.character(truthset_get[,2]))==P,3]))
        truth_GENO <- as.character(truthset_get[as.numeric(as.character(truthset_get[,2]))==P,5])
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

parse_length(Platypus_del_data,truthset.deletion,"deletion_assemble") 
parse_length(Platypus_ins_data,truthset.insertion,"insertion_assemble")













