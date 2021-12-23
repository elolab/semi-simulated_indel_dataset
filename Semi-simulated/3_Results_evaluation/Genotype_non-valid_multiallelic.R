calculate_genotype <- function(get_path)
{
  # TP result
  deletion_eval_name <- paste0(get_path,"deletion.txt")
  insertion_eval_name <- paste0(get_path,"insertion.txt")
  deletion_eval <- read.table(deletion_eval_name,header = F)
  deletion_eval <- unique(deletion_eval)
  deletion_eval <- deletion_eval[deletion_eval[,3]<5000,]
  insertion_eval <- read.table(insertion_eval_name,header = F)
  insertion_eval <- unique(insertion_eval)
  insertion_eval <- insertion_eval[insertion_eval[,3]<5000,]
  
  deletion_eval_pass <- deletion_eval[abs(as.numeric(deletion_eval[,2])-as.numeric(deletion_eval[,6]))<=10,]
  deletion_eval_pass <- deletion_eval_pass[abs(as.numeric(deletion_eval_pass[,2])-as.numeric(deletion_eval_pass[,6]))<=
                                             as.numeric(deletion_eval_pass[,7])*0.1,]
  deletion_eval_pass[deletion_eval_pass[,4]=="1|0",4] <- "0/1"
  deletion_eval_pass[deletion_eval_pass[,4]=="0|1",4] <- "0/1"
  deletion_eval_pass[deletion_eval_pass[,4]=="1|1",4] <- "1/1"
  deletion_eval_pass[deletion_eval_pass[,4]=="1/0",4] <- "0/1"
  
  insertion_eval_pass <- insertion_eval[abs(as.numeric(insertion_eval[,2])-as.numeric(insertion_eval[,6]))<=10,]
  insertion_eval_pass <- insertion_eval_pass[abs(as.numeric(insertion_eval_pass[,2])-as.numeric(insertion_eval_pass[,6]))<=
                                               as.numeric(insertion_eval_pass[,7])*0.1,]
  insertion_eval_pass[insertion_eval_pass[,4]=="1|0",4] <- "0/1"
  insertion_eval_pass[insertion_eval_pass[,4]=="0|1",4] <- "0/1"
  insertion_eval_pass[insertion_eval_pass[,4]=="1|1",4] <- "1/1"
  insertion_eval_pass[insertion_eval_pass[,4]=="1/0",4] <- "0/1"
 
  deletion_eval_pass_multi <- deletion_eval_pass[deletion_eval_pass[,4]=="1/2" | deletion_eval_pass[,4]=="0/2" |
                                              deletion_eval_pass[,4]=="2/3" | deletion_eval_pass[,4]=="2/0" | deletion_eval_pass[,4]=="2/1"|
                                                deletion_eval_pass[,4]=="3/2" | deletion_eval_pass[,4]=="1|2" | deletion_eval_pass[,4]=="2|1",]
  deletion_eval_pass_fail <- deletion_eval_pass[deletion_eval_pass[,4]=="0/0" | deletion_eval_pass[,4]=="./.",]
  
  insertion_eval_pass_multi <- insertion_eval_pass[insertion_eval_pass[,4]=="1/2" | insertion_eval_pass[,4]=="0/2" |
                                                     insertion_eval_pass[,4]=="2/3" | insertion_eval_pass[,4]=="2/0" | insertion_eval_pass[,4]=="2/1"|
                                                     insertion_eval_pass[,4]=="3/2" | insertion_eval_pass[,4]=="1|2" | insertion_eval_pass[,4]=="2|1",]
  insertion_eval_pass_fail <- insertion_eval_pass[insertion_eval_pass[,4]=="0/0" | insertion_eval_pass[,4]=="./.",]
  
  # tool set
  deletion_tool_name <- paste0(get_path,"deletion_result.txt")
  deletion_tool <- read.table(deletion_tool_name,header = F)
  deletion_tool <- unique(deletion_tool)
  deletion_tool <- deletion_tool[deletion_tool[,3]<5000,]
  insertion_tool_name <- paste0(get_path,"insertion_result.txt")
  insertion_tool <- read.table(insertion_tool_name,header = F)
  insertion_tool <- unique(insertion_tool)
  insertion_tool <- insertion_tool[insertion_tool[,3]<5000,]
  
  deletion_tool_multi <-  deletion_tool[ deletion_tool[,4]=="1/2" |  deletion_tool[,4]=="0/2" |
                                           deletion_tool[,4]=="2/3" |  deletion_tool[,4]=="2/0" |  deletion_tool[,4]=="2/1"|
                                           deletion_tool[,4]=="3/2" |  deletion_tool[,4]=="1|2" |  deletion_tool[,4]=="2|1",]
  deletion_tool_fail <-  deletion_tool[ deletion_tool[,4]=="0/0" |  deletion_tool[,4]=="./.",]
  
  insertion_tool_multi <- insertion_tool[insertion_tool[,4]=="1/2" | insertion_tool[,4]=="0/2" |
                                           insertion_tool[,4]=="2/3" | insertion_tool[,4]=="2/0" | insertion_tool[,4]=="2/1"|
                                           insertion_tool[,4]=="3/2" | insertion_tool[,4]=="1|2" | insertion_tool[,4]=="2|1",]
  insertion_tool_fail <- insertion_tool[insertion_tool[,4]=="0/0" | insertion_tool[,4]=="./.",]

  # result
  result <- c(dim(deletion_tool_multi)[1],dim(deletion_tool_fail)[1],
              dim(deletion_eval_pass_multi)[1],dim(deletion_eval_pass_fail)[1],dim(insertion_tool_multi)[1],
              dim(insertion_tool_fail)[1],dim(insertion_eval_pass_multi)[1],dim(insertion_eval_pass_fail)[1])
  
  return(result)
}

setwd("/data/epouta1/B18010_indel_tool_evaluation/Semi-simulated_chr2/Other_tools/downstream_analysis/3_Results_evaluation")
tool_sets <- c("DeepVariant","DELLY","FermiKit","GATK_HC","Pindel","Platypus","Strelka2","VarScan")
data_sets <- c("100bp_5X_500","100bp_30X_500","100bp_60X_500","250bp_30X_500","250bp_30X_800")

for (coverage in data_sets)
{
  print(coverage)
  genotype_accuracy <- vector()
  for (tool in tool_sets)
  {
    print(tool)
    path_tool <- paste0("./",coverage,"/",tool,"/")
    D <- calculate_genotype(path_tool)
    genotype_accuracy <- rbind(genotype_accuracy,D)
  }
  genotype_accuracy <- cbind(tool_sets,genotype_accuracy)
  rowname_matrix_D <- c("Callers","D_multiallele","D_failed_genotype","D_multiallele_pass","D_failed_genotype_pass",
                        "I_multiallele","I_failed_genotype","I_multiallele_pass","I_failed_genotype_pass")
  genotype_accuracy <- rbind(rowname_matrix_D,genotype_accuracy)
  
  path_dataset <- paste0("./",coverage,"/")
  genotype_accuracy_name <- paste0(path_dataset,"Genotype_accuracy_multiallele_failedG.txt")
  write.table(genotype_accuracy,genotype_accuracy_name,row.names = F,col.names = F,quote = F)
}


# coverage="100bp_30X_500"
# tool <- "Pindel"
# path_tool <- paste0("./",coverage,"/",tool,"/")
# get_path <- path_tool





# A deep learning approach for filtering structural variants in short read sequencing data




































































