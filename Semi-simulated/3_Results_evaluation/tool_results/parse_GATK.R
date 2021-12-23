generate_tool_results <- function(location_path)
{
  raw_input_pre <- read.table(paste0(location_path,"out2.recode.vcf"))
  GATK_pre <- read.table(paste0(location_path,"GATK.recode.vcf"))
  chr_pick <- c("chr1","chr2")
  GATK_indel_del_all <- vector()
  GATK_indel_ins_all <- vector()
  for (chr in chr_pick)
  {
    raw_input <- raw_input_pre[raw_input_pre[,1]==chr,]
    GATK <- GATK_pre[GATK_pre[,1]==chr,]
    
    Bio_allele <- raw_input[grepl(",",as.character(raw_input[,5])),]
    if (dim(Bio_allele)[1]!=0)
    {
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
      GATK <- rbind(GATK,Split_allele)
    }
    GATK <- GATK[order(as.numeric(GATK[,2])),]
    
    #GATK2 <- read.table("filtered_indels.vcf")
    #GATK <- GATK[as.numeric(GATK[,6]) > 280 ,] # GATK hard filter apply this
    #GATK <- GATK[GATK[,7]=="qual_test" ,]
    GATK_indel_del <- GATK[nchar(as.character(GATK[,4]))-nchar(as.character(GATK[,5])) >= 1,]
    GATK_indel_ins <- GATK[nchar(as.character(GATK[,5]))-nchar(as.character(GATK[,4])) >= 1,]
    # make all indels together
    GATK_indel_ins1 <- vector()
    GATK_indel_del1 <- vector()
    for (j in 1:dim(GATK_indel_ins)[1])
    {
      item <- vector()
      input_len <- nchar(as.character(GATK_indel_ins[j,5]))-nchar(as.character(GATK_indel_ins[j,4]))
      item_geno <- strsplit(as.character(GATK_indel_ins[j,10]),":")[[1]][1]
      item <- c(chr,GATK_indel_ins[j,2],input_len,item_geno)
      GATK_indel_ins1 <- rbind(GATK_indel_ins1,item)
    }
    for (j in 1:dim(GATK_indel_del)[1])
    {
      item <- vector()
      input_len <- nchar(as.character(GATK_indel_del[j,4]))-nchar(as.character(GATK_indel_del[j,5]))
      item_geno <- strsplit(as.character(GATK_indel_del[j,10]),":")[[1]][1]
      item <- c(chr,GATK_indel_del[j,2],input_len,item_geno)
      GATK_indel_del1 <- rbind(GATK_indel_del1,item)
    }
    GATK_indel_del1 <- data.frame(GATK_indel_del1)
    GATK_indel_ins1 <- data.frame(GATK_indel_ins1)
    
    GATK_indel_del_all <- rbind(GATK_indel_del_all,GATK_indel_del1)
    GATK_indel_ins_all <- rbind(GATK_indel_ins_all,GATK_indel_ins1)
  }
  
  print(table(GATK_indel_del_all[,4]))
  print(table(GATK_indel_ins_all[,4]))
  
  write.table(GATK_indel_del_all,paste0(location_path,"deletion_result.txt"),row.names = F,col.names = F,quote = F)
  write.table(GATK_indel_ins_all,paste0(location_path,"insertion_result.txt"),row.names = F,col.names = F,quote = F)
}

path_prefix <- "/data/epouta1/B18010_indel_tool_evaluation/Semi-simulated_chr2/Other_tools/downstream_analysis/3_Results_evaluation/"
result_path <- c("100bp_5X_500/GATK_HC/","100bp_30X_500/GATK_HC/","100bp_60X_500/GATK_HC/",
                 "250bp_30X_500/GATK_HC/","250bp_30X_800/GATK_HC/")
for (location in result_path)
{
  print(location)
  path_parse <- paste0(path_prefix,location)
  generate_tool_results(path_parse)
}














