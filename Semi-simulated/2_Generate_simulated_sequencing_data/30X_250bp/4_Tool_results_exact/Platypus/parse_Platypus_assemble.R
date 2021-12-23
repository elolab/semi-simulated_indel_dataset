raw_input_pre <- read.table("out3.recode.vcf")
Platypus_input_pre <- read.table("assembel.indel.recode.vcf")
chr_pick <- c("chr1","chr2")
Platypus_ins_data_all <- vector()
Platypus_del_data_all <- vector()
for (chr in chr_pick)
{
  raw_input <- raw_input_pre[raw_input_pre[,1]==chr,]
  Platypus_input <- Platypus_input_pre[Platypus_input_pre[,1]==chr,]
  
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
  
  Platypus_input <- rbind(Platypus_input,Split_allele)
  Platypus_input <- Platypus_input[order(as.numeric(Platypus_input[,2])),]
  
  Platypus_ins <- Platypus_input[nchar(as.character(Platypus_input[,5]))-nchar(as.character(Platypus_input[,4]))>=1,]
  Platypus_del <- Platypus_input[nchar(as.character(Platypus_input[,4]))-nchar(as.character(Platypus_input[,5]))>=1,]
  
  Platypus_ins_data <- vector()
  for (i in 1:dim(Platypus_ins)[1])
  {
    item <- vector()
    position <- as.numeric(Platypus_ins[i,2])
    length <-  abs(nchar(as.character(Platypus_ins[i,4])) - nchar(as.character(Platypus_ins[i,5])))
    item_geno <- strsplit(as.character(Platypus_ins[i,10]),":")[[1]][1]
    item <- c(chr,position,length,item_geno)
    Platypus_ins_data <- rbind(Platypus_ins_data,item)
  }
  
  Platypus_del_data <- vector()
  for (i in 1:dim(Platypus_del)[1])
  {
    item <- vector()
    position <- as.numeric(Platypus_del[i,2])
    length <-  abs(nchar(as.character(Platypus_del[i,4])) - nchar(as.character(Platypus_del[i,5])))
    item_geno <- strsplit(as.character(Platypus_del[i,10]),":")[[1]][1]
    item <- c(chr,position,length,item_geno)
    Platypus_del_data <- rbind(Platypus_del_data,item)
  }
  
  Platypus_ins_data <- data.frame(Platypus_ins_data)
  Platypus_del_data <- data.frame(Platypus_del_data)
  
  Platypus_ins_data_all <- rbind(Platypus_ins_data_all,Platypus_ins_data)
  Platypus_del_data_all <- rbind(Platypus_del_data_all,Platypus_del_data)
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

parse_length(Platypus_del_data_all,truthset.deletion,"deletion_assemble") 
parse_length(Platypus_ins_data_all,truthset.insertion,"insertion_assemble")
