generate_tool_results <- function(location_path)
{
  # split into subsets
  Pindel_del_data_all <- vector()
  Pindel_del_pre <- read.table(paste0(location_path,"Pindel_simulatedD_D.vcf"))
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
  
  Pindel_dup_pre <- read.table(paste0(location_path,"Pindel_simulatedD_TD.vcf"))
  Pindel_dup_data_all <- vector()
  chr_pick <- c("chr1","chr2")
  for (chr in chr_pick)
  {
    Pindel_dup <- Pindel_dup_pre[Pindel_dup_pre[,1]==chr,]
    # split into sunsets
    Pindel_dup_data <- vector()
    for (i in 1:dim(Pindel_dup)[1])
    {
      item <- vector()
      # get length information from INFO column
      position <- Pindel_dup[i,2]
      Pindel_dup_info<- strsplit(as.character(Pindel_dup[i,8]),";")[[1]]
      Pindel_dup_len <- Pindel_dup_info[grep("SVLEN=",Pindel_dup_info)]
      Pindel_dup_LEN <- substr(as.character(Pindel_dup_len),7,nchar(Pindel_dup_len)) 
      geno <- strsplit(as.character(Pindel_dup[i,10]),":")[[1]][1]
      item <- c(chr,position,Pindel_dup_LEN,geno)
      Pindel_dup_data <- rbind(Pindel_dup_data,item)
    }
    Pindel_dup_data <- data.frame(Pindel_dup_data)
    Pindel_dup_data_all <- rbind(Pindel_dup_data_all,Pindel_dup_data)
  }
  
  SIe5_pre <- read.table(paste0(location_path,"Pindel_simulatedD_SI.vcf"))
  Pindel_ins_data_all <- vector()
  chr_pick <- c("chr1","chr2")
  for (chr in chr_pick)
  {
    SIe5 <- SIe5_pre[SIe5_pre[,1]==chr,]
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
      item <- c(chr,position,Pindel_ins_LEN,geno)
      Pindel_ins_data <- rbind(Pindel_ins_data,item)
    }
    Pindel_ins_data <- data.frame(Pindel_ins_data)
    Pindel_ins_data_all <- rbind(Pindel_ins_data_all,Pindel_ins_data)
  }
  Pindel_ins_data_all <- rbind(Pindel_ins_data_all,Pindel_dup_data_all)
  
  print(table(Pindel_del_data_all[,4]))
  print(table(Pindel_ins_data_all[,4]))
  
  write.table(Pindel_del_data_all,paste0(location_path,"deletion_result.txt"),row.names = F,col.names = F,quote = F)
  write.table(Pindel_ins_data_all ,paste0(location_path,"insertion_result.txt"),row.names = F,col.names = F,quote = F)
}

path_prefix <- "/data/epouta1/B18010_indel_tool_evaluation/Semi-simulated_chr2/Other_tools/downstream_analysis/3_Results_evaluation/"
result_path <- c("100bp_5X_500/Pindel/","100bp_30X_500/Pindel/","100bp_60X_500/Pindel/",
                 "250bp_30X_500/Pindel/","250bp_30X_800/Pindel/")
for (location in result_path)
{
  print(location)
  path_parse <- paste0(path_prefix,location)
  generate_tool_results(path_parse)
}
































































