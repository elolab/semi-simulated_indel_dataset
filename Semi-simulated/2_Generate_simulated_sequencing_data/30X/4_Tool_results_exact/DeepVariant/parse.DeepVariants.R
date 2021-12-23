raw_input_pre <- read.table("out2.recode.vcf")
DeepVariant_sv_pre <- read.table("deepVariants.recode.vcf")
chr_pick <- c("chr1","chr2")
DeepVariant_del_all <- vector()
DeepVariant_ins_all <- vector()
for (chr in chr_pick)
{
  raw_input <- raw_input_pre[raw_input_pre[,1]==chr,]
  DeepVariant_sv <- DeepVariant_sv_pre[DeepVariant_sv_pre[,1]==chr,]
  
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
  
  DeepVariant_sv <- rbind(DeepVariant_sv,Split_allele)
  DeepVariant_sv <- DeepVariant_sv[order(as.numeric(DeepVariant_sv[,2])),]
  
  DeepVariant_ins <- DeepVariant_sv[nchar(as.character(DeepVariant_sv[,5]))-nchar(as.character(DeepVariant_sv[,4]))>=1,]
  DeepVariant_del <- DeepVariant_sv[nchar(as.character(DeepVariant_sv[,4]))-nchar(as.character(DeepVariant_sv[,5]))>=1,]
  
  DeepVariant_ins1 <- vector()
  DeepVariant_del1 <- vector()
  for (j in 1:dim(DeepVariant_ins)[1])
  {
    item <- vector()
    input_len <- nchar(as.character(DeepVariant_ins[j,5]))-nchar(as.character(DeepVariant_ins[j,4])) 
    item_geno <- strsplit(as.character(DeepVariant_ins[j,10]),":")[[1]][1]
    item <- c(chr,DeepVariant_ins[j,2],input_len,item_geno)
    DeepVariant_ins1 <- rbind(DeepVariant_ins1,item)
  }
  for (j in 1:dim(DeepVariant_del)[1])
  {
    item <- vector()
    input_len <- nchar(as.character(DeepVariant_del[j,4]))-nchar(as.character(DeepVariant_del[j,5])) 
    item_geno <- strsplit(as.character(DeepVariant_del[j,10]),":")[[1]][1]
    item <- c(chr,DeepVariant_del[j,2],input_len,item_geno)
    DeepVariant_del1 <- rbind(DeepVariant_del1,item)
  }
  DeepVariant_del1 <- data.frame(DeepVariant_del1)
  DeepVariant_ins1 <- data.frame(DeepVariant_ins1)
  
  DeepVariant_del_all <- rbind(DeepVariant_del_all,DeepVariant_del1)
  DeepVariant_ins_all <- rbind(DeepVariant_ins_all,DeepVariant_ins1)
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
          P_input_LEN <- as.numeric(as.character(P_input_get[P_input_get[,2]==P-deviation,3]))
          P_input_GENO <- as.character(P_input_get[P_input_get[,2]==P-deviation,4])
          truth_length <- as.numeric(as.character(truthset_get[as.numeric(as.character(truthset_get[,2]))==P,3]))
          truth_GENO <- as.character(truthset_get[as.numeric(as.character(truthset_get[,2]))==P,5])

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

parse_length(DeepVariant_del_all,truthset.deletion,"deletion")
parse_length(DeepVariant_ins_all,truthset.insertion,"insertion")
