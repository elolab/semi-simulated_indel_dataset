generate_tool_results <- function(location_path)
{
  raw_input_pre <- read.table(paste0(location_path,"out2.recode.vcf"))
  Strelka2_pre <- read.table(paste0(location_path,"variants.indel.recode.vcf"))
  chr_pick <- c("chr1","chr2")
  Strelka2_ins_data_all <- vector()
  Strelka2_del_data_all <- vector()
  for (chr in chr_pick)
  {
    raw_input <- raw_input_pre[raw_input_pre[,1]==chr,]
    Strelka2 <- Strelka2_pre[Strelka2_pre[,1]==chr,]
    
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
    
    Strelka2 <- rbind(Strelka2,Split_allele)
    Strelka2 <- Strelka2[order(as.numeric(Strelka2[,2])),]
    
    Strelka2_ins <- Strelka2[nchar(as.character(Strelka2[,5]))-nchar(as.character(Strelka2[,4]))>=1,]
    Strelka2_del <- Strelka2[nchar(as.character(Strelka2[,4]))-nchar(as.character(Strelka2[,5]))>=1,]
    
    Strelka2_ins_data <- vector()
    for (i in 1:dim(Strelka2_ins)[1])
    {
      item <- vector()
      position <- as.numeric(Strelka2_ins[i,2])
      length <-  abs(nchar(as.character(Strelka2_ins[i,4])) - nchar(as.character(Strelka2_ins[i,5])))
      item_geno <- strsplit(as.character(Strelka2_ins[i,10]),":")[[1]][1]
      item <- c(chr,position,length,item_geno)
      Strelka2_ins_data <- rbind(Strelka2_ins_data,item)
    }
    
    Strelka2_del_data <- vector()
    for (i in 1:dim(Strelka2_del)[1])
    {
      item <- vector()
      position <- as.numeric(Strelka2_del[i,2])
      length <-  abs(nchar(as.character(Strelka2_del[i,4])) - nchar(as.character(Strelka2_del[i,5])))
      item_geno <- strsplit(as.character(Strelka2_del[i,10]),":")[[1]][1]
      item <- c(chr,position,length,item_geno)
      Strelka2_del_data <- rbind(Strelka2_del_data,item)
    }
    
    Strelka2_ins_data <- data.frame(Strelka2_ins_data)
    Strelka2_del_data <- data.frame(Strelka2_del_data)
    
    Strelka2_ins_data_all <- rbind(Strelka2_ins_data_all,Strelka2_ins_data)
    Strelka2_del_data_all <- rbind(Strelka2_del_data_all,Strelka2_del_data)
  }  
  
  print(table(Strelka2_del_data_all[,4]))
  print(table(Strelka2_ins_data_all[,4]))
  
  write.table(Strelka2_del_data_all,paste0(location_path,"deletion_result.txt"),row.names = F,col.names = F,quote = F)
  write.table(Strelka2_ins_data_all,paste0(location_path,"insertion_result.txt"),row.names = F,col.names = F,quote = F)
}

path_prefix <- "/data/epouta1/B18010_indel_tool_evaluation/Semi-simulated_chr2/Other_tools/downstream_analysis/3_Results_evaluation/"
result_path <- c("100bp_5X_500/Strelka2/","100bp_30X_500/Strelka2/","100bp_60X_500/Strelka2/",
                 "250bp_30X_500/Strelka2/","250bp_30X_800/Strelka2/")
for (location in result_path)
{
  print(location)
  path_parse <- paste0(path_prefix,location)
  generate_tool_results(path_parse)
}

























