fermikit_sv_pre <- read.table("fermikit.sv.vcf")
fermikit_sv_ins_all <- vector()
fermikit_sv_del_all <- vector()
raw_input_pre <- read.table("out2.recode.vcf")
fermikit_flt_pre <- read.table("fermikit.flt.recode.vcf")

chr_pick <- c("chr1","chr2")
for (chr in chr_pick)
{
  fermikit_sv <- fermikit_sv_pre[fermikit_sv_pre[,1]==chr,]
  raw_input <- raw_input_pre[raw_input_pre[,1]==chr,]
  fermikit_flt <- fermikit_flt_pre[fermikit_flt_pre[,1]==chr,]
  
  fermikit_sv_ins <- vector()
  fermikit_sv_del <- vector()
  
  for (i in 1: dim(fermikit_sv)[1])
  {
    item <- vector()
    input_info <- strsplit(as.character(fermikit_sv[i,8]),";")[[1]]
    input_type <- input_info[grep("SVTYPE=",input_info)]
    input_len <- input_info[grep("SVLEN=",input_info)]
    input_LEN <- substr(as.character(input_len),7,nchar(input_len))
    if (input_type == "SVTYPE=INS")
    {
      item <- c(chr,fermikit_sv[i,2],input_LEN,"0/0")
      fermikit_sv_ins <- rbind(fermikit_sv_ins,item)  
    }
    else if (input_type == "SVTYPE=DEL")
    {
      item <- c(chr,fermikit_sv[i,2],input_LEN,"0/0")
      fermikit_sv_del <- rbind(fermikit_sv_del,item)  
    }
  }
  
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
  
  fermikit_flt <- rbind(fermikit_flt,Split_allele)
  fermikit_flt <- fermikit_flt[order(as.numeric(fermikit_flt[,2])),]
  
  rownames(fermikit_flt) <- seq(length=nrow(fermikit_flt))
  fermikit_flt_ins <- fermikit_flt[nchar(as.character(fermikit_flt[,5]))-nchar(as.character(fermikit_flt[,4]))>=1,]
  fermikit_flt_del <- fermikit_flt[nchar(as.character(fermikit_flt[,4]))-nchar(as.character(fermikit_flt[,5]))>=1,]

  for (j in 1:dim(fermikit_flt_ins)[1])
  {
    item <- vector()
    input_len <- nchar(as.character(fermikit_flt_ins[j,5]))-nchar(as.character(fermikit_flt_ins[j,4])) 
    item_geno <- strsplit(as.character(fermikit_flt_ins[j,10]),":")[[1]][1]
    item <- c(chr,fermikit_flt_ins[j,2],input_len,item_geno)
    fermikit_sv_ins <- rbind(fermikit_sv_ins,item)  
  }
  for (j in 1:dim(fermikit_flt_del)[1])
  {
    item <- vector()
    input_len <- nchar(as.character(fermikit_flt_del[j,4]))-nchar(as.character(fermikit_flt_del[j,5])) 
    item_geno <- strsplit(as.character(fermikit_flt_del[j,10]),":")[[1]][1]
    item <- c(chr,fermikit_flt_del[j,2],input_len,item_geno)
    fermikit_sv_del <- rbind(fermikit_sv_del,item)  
  }

  rownames(fermikit_sv_del) <- seq(length=nrow(fermikit_sv_del))
  fermikit_sv_del <- data.frame(fermikit_sv_del)
  fermikit_sv_del <- fermikit_sv_del[order(as.numeric(as.character(fermikit_sv_del$X2))),]
  rownames(fermikit_sv_del) <- seq(length=nrow(fermikit_sv_del))
  rownames(fermikit_sv_ins) <- seq(length=nrow(fermikit_sv_ins))
  fermikit_sv_ins <- data.frame(fermikit_sv_ins)
  fermikit_sv_ins <- fermikit_sv_ins[order(as.numeric(as.character(fermikit_sv_ins$X2))),]
  rownames(fermikit_sv_ins) <- seq(length=nrow(fermikit_sv_ins))
  fermikit_sv_del <- data.frame(fermikit_sv_del)
  fermikit_sv_ins <- data.frame(fermikit_sv_ins)
  
  fermikit_sv_del_all <- rbind(fermikit_sv_del_all,fermikit_sv_del)
  fermikit_sv_ins_all <- rbind(fermikit_sv_ins_all,fermikit_sv_ins)
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

parse_length(fermikit_sv_del_all,truthset.deletion,"deletion")
parse_length(fermikit_sv_ins_all,truthset.insertion,"insertion")
