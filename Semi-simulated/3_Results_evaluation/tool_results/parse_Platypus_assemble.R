generate_tool_results <- function(location_path)
{
  raw_input_pre <- read.table(paste0(location_path,"out3.recode.vcf"))
  Platypus_input_pre <- read.table(paste0(location_path,"assembel.indel.recode.vcf"))
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
    
    # get some SNV, which can be false positive
    Platypus_ins_data <- vector()
    for (i in 1:dim(Platypus_ins)[1])
    {
      item <- vector()
      position <- as.numeric(Platypus_ins[i,2])#+nchar(as.character(Platypus_ins[i,5]))
      length <-  abs(nchar(as.character(Platypus_ins[i,4])) - nchar(as.character(Platypus_ins[i,5])))
      item_geno <- strsplit(as.character(Platypus_ins[i,10]),":")[[1]][1]
      item <- c(chr,position,length,item_geno)
      Platypus_ins_data <- rbind(Platypus_ins_data,item)
    }
    
    Platypus_del_data <- vector()
    for (i in 1:dim(Platypus_del)[1])
    {
      item <- vector()
      position <- as.numeric(Platypus_del[i,2])#+nchar(as.character(Platypus_del[i,5]))
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
  
  print(table(Platypus_del_data_all[,4]))
  print(table(Platypus_ins_data_all[,4]))
  
  write.table(Platypus_del_data_all,paste0(location_path,"deletion_result.txt"),row.names = F,col.names = F,quote = F)
  write.table(Platypus_ins_data_all,paste0(location_path,"insertion_result.txt"),row.names = F,col.names = F,quote = F)
}

path_prefix <- "/data/epouta1/B18010_indel_tool_evaluation/Semi-simulated_chr2/Other_tools/downstream_analysis/3_Results_evaluation/"
result_path <- c("100bp_5X_500/Platypus/","100bp_30X_500/Platypus/","100bp_60X_500/Platypus/",
                 "250bp_30X_500/Platypus/","250bp_30X_800/Platypus/")
for (location in result_path)
{
  print(location)
  path_parse <- paste0(path_prefix,location)
  generate_tool_results(path_parse)
}












