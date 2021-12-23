calculate_genotype <- function(get_path,range)
{
  # TP result
  deletion_eval_name <- paste0(get_path,"deletion.txt")
  insertion_eval_name <- paste0(get_path,"insertion.txt")
  deletion_eval <- read.table(deletion_eval_name,header = F)
  deletion_eval <- unique(deletion_eval)
  deletion_eval <- deletion_eval[deletion_eval[,3]>=range[1] & deletion_eval[,3]<range[2],]
  insertion_eval <- read.table(insertion_eval_name,header = F)
  insertion_eval <- unique(insertion_eval)
  insertion_eval <- insertion_eval[insertion_eval[,3]>=range[1] & insertion_eval[,3]<range[2],]
  
  deletion_eval_pass <- deletion_eval[abs(as.numeric(deletion_eval[,2])-as.numeric(deletion_eval[,6]))<=10,]
  deletion_eval_pass <- deletion_eval_pass[abs(as.numeric(deletion_eval_pass[,2])-as.numeric(deletion_eval_pass[,6]))<=
                                             as.numeric(deletion_eval_pass[,7])*0.1,]
  deletion_eval_pass[deletion_eval_pass[,4]=="1|0",4] <- "0/1"
  deletion_eval_pass[deletion_eval_pass[,4]=="0|1",4] <- "0/1"
  deletion_eval_pass[deletion_eval_pass[,4]=="1|1",4] <- "1/1"
  deletion_eval_pass[deletion_eval_pass[,4]=="1/0",4] <- "0/1"
  deletion_eval_pass2 <- deletion_eval_pass[as.character(deletion_eval_pass[,4])==as.character(deletion_eval_pass[,8]),]
  
  insertion_eval_pass <- insertion_eval[abs(as.numeric(insertion_eval[,2])-as.numeric(insertion_eval[,6]))<=10,]
  insertion_eval_pass <- insertion_eval_pass[abs(as.numeric(insertion_eval_pass[,2])-as.numeric(insertion_eval_pass[,6]))<=
                                               as.numeric(insertion_eval_pass[,7])*0.1,]
  insertion_eval_pass[insertion_eval_pass[,4]=="1|0",4] <- "0/1"
  insertion_eval_pass[insertion_eval_pass[,4]=="0|1",4] <- "0/1"
  insertion_eval_pass[insertion_eval_pass[,4]=="1|1",4] <- "1/1"
  insertion_eval_pass[insertion_eval_pass[,4]=="1/0",4] <- "0/1"
  insertion_eval_pass2 <- insertion_eval_pass[as.character(insertion_eval_pass[,4])==as.character(insertion_eval_pass[,8]),]

  indel_eval_pass2 <- rbind(deletion_eval_pass2,insertion_eval_pass2)
  indel_eval_pass_homo <- indel_eval_pass2[indel_eval_pass2[,4]=="1/1",]
  indel_eval_pass_heter <- indel_eval_pass2[indel_eval_pass2[,4]=="0/1",]
  
  # tool set
  deletion_tool_name <- paste0(get_path,"deletion_result.txt")
  deletion_tool <- read.table(deletion_tool_name,header = F)
  deletion_tool <- unique(deletion_tool)
  deletion_tool <- deletion_tool[deletion_tool[,3]>=range[1] & deletion_tool[,3]<range[2],]
  deletion_tool[deletion_tool[,4]=="1|0",4] <- "0/1"
  deletion_tool[deletion_tool[,4]=="0|1",4] <- "0/1"
  deletion_tool[deletion_tool[,4]=="1|1",4] <- "1/1"
  deletion_tool[deletion_tool[,4]=="1/0",4] <- "0/1"
  
  insertion_tool_name <- paste0(get_path,"insertion_result.txt")
  insertion_tool <- read.table(insertion_tool_name,header = F)
  insertion_tool <- unique(insertion_tool)
  insertion_tool <- insertion_tool[insertion_tool[,3]>=range[1] & insertion_tool[,3]<range[2],]
  insertion_tool[insertion_tool[,4]=="1|0",4] <- "0/1"
  insertion_tool[insertion_tool[,4]=="0|1",4] <- "0/1"
  insertion_tool[insertion_tool[,4]=="1|1",4] <- "1/1"
  insertion_tool[insertion_tool[,4]=="1/0",4] <- "0/1"
  
  indel_tool <- rbind(deletion_tool,insertion_tool)
  indel_tool_homo <- indel_tool[indel_tool[,4]=="1/1",]
  indel_tool_heter <- indel_tool[indel_tool[,4]=="0/1" | indel_tool[,4]=="1/2" | indel_tool[,4]=="0/2" |
                                indel_tool[,4]=="2/3" | indel_tool[,4]=="2/0" | indel_tool[,4]=="2/1"|
                                indel_tool[,4]=="3/2" | indel_tool[,4]=="1|2" | indel_tool[,4]=="2|1",]
  
  homo_precision <- dim(indel_eval_pass_homo)[1]/dim(indel_tool_homo)[1]
  heter_precision <- dim(indel_eval_pass_heter)[1]/dim(indel_tool_heter)[1]

  result <- c(homo_precision,heter_precision)
  
  return(result)
}

tool_sets <- c("DeepVariant","DELLY","FermiKit","GATK_HC","Pindel","Platypus","Strelka2","VarScan")
data_sets <- c("100bp_5X_500","100bp_30X_500","100bp_60X_500","250bp_30X_500","250bp_30X_800")

for (coverage in data_sets)
{
  print(coverage)
  genotype_accuracy <- vector()
  genotype_accuracy_small <- vector()
  genotype_accuracy_large <- vector()
  for (tool in tool_sets)
  {
    print(tool)
    path_tool <- paste0("/3_Results_evaluation/",
                        coverage,"/",tool,"/")
    D <- calculate_genotype(path_tool,c(1,5000))
    genotype_accuracy <- rbind(genotype_accuracy,D)
    D_small <- calculate_genotype(path_tool,c(1,50))
    genotype_accuracy_small <- rbind(genotype_accuracy_small,D_small)
    D_large <- calculate_genotype(path_tool,c(50,5000))
    genotype_accuracy_large <- rbind(genotype_accuracy_large,D_large)
  }
  genotype_accuracy <- cbind(tool_sets,genotype_accuracy)
  genotype_accuracy_small <- cbind(tool_sets,genotype_accuracy_small)
  genotype_accuracy_large <- cbind(tool_sets,genotype_accuracy_large)
  
  # rowname_matrix_D <- c("Callers","homo_precision","heter_precision","failed_genotype")
  rowname_matrix_D <- c("Callers","homo_precision","heter_precision")
  genotype_accuracy <- rbind(rowname_matrix_D,genotype_accuracy)
  genotype_accuracy_small <- rbind(rowname_matrix_D,genotype_accuracy_small)
  genotype_accuracy_large <- rbind(rowname_matrix_D,genotype_accuracy_large)
  
  path_dataset <- paste0("/3_Results_evaluation/",coverage,"/")
  genotype_accuracy_name <- paste0(path_dataset,"Genotype_accuracy.txt")
  write.table(genotype_accuracy,genotype_accuracy_name,row.names = F,col.names = F,quote = F)
  genotype_accuracy_name_small <- paste0(path_dataset,"Genotype_accuracy_small.txt")
  write.table(genotype_accuracy_small,genotype_accuracy_name_small,row.names = F,col.names = F,quote = F)
  genotype_accuracy_name_large <- paste0(path_dataset,"Genotype_accuracy_large.txt")
  write.table(genotype_accuracy_large,genotype_accuracy_name_large,row.names = F,col.names = F,quote = F)
}














































































