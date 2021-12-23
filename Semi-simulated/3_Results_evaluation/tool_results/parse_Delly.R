generate_tool_results <- function(location_path)
{
  Delly_input <- read.table(paste0(location_path,"delly_default.vcf"))
  Delly_del <- vector()
  Delly_ins <- vector()
  Delly_dup <- vector()
  # type <- vector()
  for (i in 1:dim(Delly_input)[1])
  {
    Delly_input_info <- strsplit(as.character(Delly_input[i,8]),";")[[1]]
    Delly_input_type <- Delly_input_info[grep("SVTYPE=",Delly_input_info)]
    Delly_input_TYPE <- substr(as.character(Delly_input_type),8,nchar(Delly_input_type))
    # type <- c(type,Delly_input_TYPE) contain "DEL" "DUP" "INS" "INV"
    if (Delly_input_TYPE == "DEL")
    {
      Delly_del <- rbind(Delly_del,Delly_input[i,])
    }
    else if (Delly_input_TYPE == "INS")
    {
      Delly_ins <- rbind(Delly_ins,Delly_input[i,])
    }
    else if (Delly_input_TYPE == "DUP")
    {
      Delly_dup <- rbind(Delly_dup,Delly_input[i,])
    }
  }
  
  Delly_del_data <- vector()
  for (i in 1:dim(Delly_del)[1])
  {
    item <- vector()
    # get length information from INFO column
    chromosome <- Delly_del[i,1]
    position <- Delly_del[i,2]
    Delly_del_SV_start <- Delly_del[i,2]
    Delly_del_info <- strsplit(as.character(Delly_del[i,8]),";")[[1]]
    Delly_del_input_end <- Delly_del_info[grep("END=",Delly_del_info)][1]
    Delly_del_SV_END <- as.numeric(substr(as.character(Delly_del_input_end),5,nchar(Delly_del_input_end)))
    Delly_del_input_LEN <- Delly_del_SV_END-Delly_del_SV_start-1
    item_geno <- strsplit(as.character(Delly_del[i,10]),":")[[1]][1]
    item <- c(chromosome,position,Delly_del_input_LEN,item_geno)
    Delly_del_data <- rbind(Delly_del_data,item)
  }
  Delly_del_data <- data.frame(Delly_del_data)
  
  if (dim(Delly_ins)[1]!=0)
  {
    Delly_ins_data <- vector()
    for (i in 1:dim(Delly_ins)[1])
    {
      item <- vector()
      chromosome <- Delly_ins[i,1]
      # get length information from INFO column
      position <- Delly_ins[i,2]
      Delly_ins_SV_start <- Delly_ins[i,2]
      Delly_ins_info <- strsplit(as.character(Delly_ins[i,8]),";")[[1]]
      Delly_ins_input_len <- Delly_ins_info[grep("INSLEN=",Delly_ins_info)][1]
      Delly_ins_input_LEN <- as.numeric(substr(as.character(Delly_ins_input_len),8,nchar(Delly_ins_input_len)))
      item_geno <- strsplit(as.character(Delly_ins[i,10]),":")[[1]][1]
      item <- c(chromosome,position,Delly_ins_input_LEN,item_geno)
      Delly_ins_data <- rbind(Delly_ins_data,item)
    }
    Delly_ins_data <- data.frame(Delly_ins_data)
  }
  
  Delly_dup_data <- vector()
  for (i in 1:dim(Delly_dup)[1])
  {
    item <- vector()
    # get length information from INFO column
    chromosome <- Delly_dup[i,1]
    position <- Delly_dup[i,2]
    Delly_dup_SV_start <- Delly_dup[i,2]
    Delly_dup_info <- strsplit(as.character(Delly_dup[i,8]),";")[[1]]
    Delly_dup_input_end <- Delly_dup_info[grep("END=",Delly_dup_info)][1]
    Delly_dup_SV_END <- as.numeric(substr(as.character(Delly_dup_input_end),5,nchar(Delly_dup_input_end)))
    Delly_dup_input_LEN <- Delly_dup_SV_END-Delly_dup_SV_start
    item_geno <- strsplit(as.character(Delly_dup[i,10]),":")[[1]][1]
    item <- c(chromosome,position,Delly_dup_input_LEN,item_geno)
    Delly_dup_data <- rbind(Delly_dup_data,item)
  }
  Delly_dup_data <- data.frame(Delly_dup_data)
  Delly_ins_data <- rbind(Delly_ins_data,Delly_dup_data)
  
  print(table(Delly_del_data[,4]))
  print(table(Delly_ins_data[,4]))
  
  write.table(Delly_del_data,paste0(location_path,"deletion_result.txt"),row.names = F,col.names = F,quote = F)
  write.table(Delly_ins_data,paste0(location_path,"insertion_result.txt"),row.names = F,col.names = F,quote = F)
}


path_prefix <- "/data/epouta1/B18010_indel_tool_evaluation/Semi-simulated_chr2/Other_tools/downstream_analysis/3_Results_evaluation/"
result_path <- c("100bp_5X_500/DELLY/","100bp_30X_500/DELLY/","100bp_60X_500/DELLY/",
                 "250bp_30X_500/DELLY/","250bp_30X_800/DELLY/")
for (location in result_path)
{
  print(location)
  path_parse <- paste0(path_prefix,location)
  generate_tool_results(path_parse)
}






