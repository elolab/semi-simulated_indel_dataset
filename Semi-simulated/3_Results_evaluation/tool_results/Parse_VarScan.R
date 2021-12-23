generate_tool_results <- function(location_path)
{
  VarScan_pre <- read.table(paste0(location_path,"varscan_indel.vcf"))
  chr_pick <- c("chr1","chr2")
  VarScan_indel_del1_all <- vector()
  VarScan_indel_ins1_all <- vector()
  for (chr in chr_pick)
  {
    VarScan <- VarScan_pre[VarScan_pre[,1]==chr,]
    
    VarScan_indel_del <- VarScan[nchar(as.character(VarScan[,4]))-nchar(as.character(VarScan[,5])) >= 1,]
    VarScan_indel_ins <- VarScan[nchar(as.character(VarScan[,5]))-nchar(as.character(VarScan[,4])) >= 1,]
    # make all indels together
    VarScan_indel_ins1 <- vector()
    VarScan_indel_del1 <- vector()
    for (j in 1:dim(VarScan_indel_ins)[1])
    {
      item <- vector()
      input_len <- nchar(as.character(VarScan_indel_ins[j,5]))-nchar(as.character(VarScan_indel_ins[j,4]))
      item_geno <- strsplit(as.character(VarScan_indel_ins[j,10]),":")[[1]][1]
      item <- c(chr,VarScan_indel_ins[j,2],input_len,item_geno)
      VarScan_indel_ins1 <- rbind(VarScan_indel_ins1,item)
    }
    for (j in 1:dim(VarScan_indel_del)[1])
    {
      item <- vector()
      input_len <- nchar(as.character(VarScan_indel_del[j,4]))-nchar(as.character(VarScan_indel_del[j,5]))
      item_geno <- strsplit(as.character(VarScan_indel_del[j,10]),":")[[1]][1]
      item <- c(chr,VarScan_indel_del[j,2],input_len,item_geno)
      VarScan_indel_del1 <- rbind(VarScan_indel_del1,item)
    }
    
    VarScan_indel_del1 <- data.frame(VarScan_indel_del1)
    VarScan_indel_ins1 <- data.frame(VarScan_indel_ins1)
    VarScan_indel_del1_all <- rbind(VarScan_indel_del1_all,VarScan_indel_del1)
    VarScan_indel_ins1_all <- rbind(VarScan_indel_ins1_all,VarScan_indel_ins1)
  }
  
  print(table(VarScan_indel_del1_all[,4]))
  print(table(VarScan_indel_ins1_all[,4]))
  
  write.table(VarScan_indel_del1_all,paste0(location_path,"deletion_result.txt"),row.names = F,col.names = F,quote = F)
  write.table(VarScan_indel_ins1_all,paste0(location_path,"insertion_result.txt"),row.names = F,col.names = F,quote = F)
}

path_prefix <- "/data/epouta1/B18010_indel_tool_evaluation/Semi-simulated_chr2/Other_tools/downstream_analysis/3_Results_evaluation/"
result_path <- c("100bp_5X_500/VarScan/","100bp_30X_500/VarScan/","100bp_60X_500/VarScan/",
                 "250bp_30X_500/VarScan/","250bp_30X_800/VarScan/")
for (location in result_path)
{
  print(location)
  path_parse <- paste0(path_prefix,location)
  generate_tool_results(path_parse)
}



