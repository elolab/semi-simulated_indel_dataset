options(scipen = 999)

results_calculate <- function(T_deletion,T_insertion,get_path)
{
  deletion_eval_name <- paste0(get_path,"deletion.txt")
  insertion_eval_name <- paste0(get_path,"insertion.txt")
  deletion_eval <- read.table(deletion_eval_name,header = F)
  deletion_eval <- unique(deletion_eval)
  insertion_eval <- read.table(insertion_eval_name,header = F)
  insertion_eval <- unique(insertion_eval)
  
  deletion_eval_pass <- deletion_eval[abs(as.numeric(deletion_eval[,2])-as.numeric(deletion_eval[,6]))<=
                                             as.numeric(deletion_eval[,7])*0.1,]
  deletion_eval_pass <- deletion_eval_pass[abs(as.numeric(deletion_eval_pass[,2])-
                                                 as.numeric(deletion_eval_pass[,6]))<=50,]
  deletion_eval_pass[deletion_eval_pass[,4]=="1|0",4] <- "0/1"
  deletion_eval_pass[deletion_eval_pass[,4]=="0|1",4] <- "0/1"
  deletion_eval_pass[deletion_eval_pass[,4]=="1|1",4] <- "1/1"
  deletion_eval_pass[deletion_eval_pass[,4]=="1/0",4] <- "0/1"
  deletion_eval_pass <- deletion_eval_pass[as.character(deletion_eval_pass[,4])==as.character(deletion_eval_pass[,8]),]
  
  insertion_eval_pass <- insertion_eval[abs(as.numeric(insertion_eval[,2])-as.numeric(insertion_eval[,6]))<=
                                               as.numeric(insertion_eval[,7])*0.1,]
  insertion_eval_pass <- insertion_eval_pass[abs(as.numeric(insertion_eval_pass[,2])-
                                                   as.numeric(insertion_eval_pass[,6]))<=50,]
  insertion_eval_pass[insertion_eval_pass[,4]=="1|0",4] <- "0/1"
  insertion_eval_pass[insertion_eval_pass[,4]=="0|1",4] <- "0/1"
  insertion_eval_pass[insertion_eval_pass[,4]=="1|1",4] <- "1/1"
  insertion_eval_pass[insertion_eval_pass[,4]=="1/0",4] <- "0/1"
  insertion_eval_pass <- insertion_eval_pass[as.character(insertion_eval_pass[,4])==as.character(insertion_eval_pass[,8]),]
  
  deletion_tool_name <- paste0(get_path,"deletion_result.txt")
  insertion_tool_name <- paste0(get_path,"insertion_result.txt")
  deletion_tool <- read.table(deletion_tool_name,header = F)
  deletion_tool <- unique(deletion_tool)
  insertion_tool <- read.table(insertion_tool_name,header = F)
  insertion_tool <- unique(insertion_tool)
  
  interval_1 <- c(1,10,20,30,40)
  interval_2 <- c(10,20,30,40,50)
  
  parse_length <- function(P_input_get,truth_set,query_set,interval_1,interval_2)
  {
    precision <- vector()
    recall <- vector()
    for(i in 1:length(interval_1))
    {
      Resutls_tool <- P_input_get[as.numeric(as.character(P_input_get[,3])) >= as.numeric(interval_1[i]) 
                                  & as.numeric(as.character(P_input_get[,3])) < as.numeric(interval_2[i]),]
      Results_truth <- P_input_get[as.numeric(as.character(P_input_get[,7])) >= as.numeric(interval_1[i]) 
                                   & as.numeric(as.character(P_input_get[,7])) < as.numeric(interval_2[i]),]
      Raw_tools <- query_set[as.numeric(as.character(query_set[,3])) >= as.numeric(interval_1[i]) 
                             & as.numeric(as.character(query_set[,3])) < as.numeric(interval_2[i]),]
      Raw_truth <- truth_set[as.numeric(as.character(truth_set[,3])) >= as.numeric(interval_1[i]) 
                             & as.numeric(as.character(truth_set[,3])) < as.numeric(interval_2[i]),]
      
      precision <- c(precision,dim(Resutls_tool)[1]/dim(Raw_tools)[1])
      recall <- c(recall,(dim(Results_truth)[1]/dim(Raw_truth)[1]))
    }
    result_matrix <- rbind(precision,recall)
    return(result_matrix)
  }
  A <- parse_length(deletion_eval_pass,T_deletion, deletion_tool,interval_1,interval_2)
  B <- parse_length(insertion_eval_pass,T_insertion, insertion_tool,interval_1,interval_2)
  C <- rbind(A,B)
  return(C)
}


setwd("/data/epouta1/B18010_indel_tool_evaluation/Semi-simulated_chr2/Other_tools/downstream_analysis/3_Results_evaluation/")
truthset_ground <- read.table("chr1_chr2_variants_truthset.txt")
new.position <- as.numeric(as.character(truthset_ground[,2]))
truthset_ground <- cbind(truthset_ground,new.position)
truthset_ground[truthset_ground[,5]=="1/0",5] <- "0/1"
truthset.deletion <- truthset_ground[truthset_ground[,1]=="deletion",]
truthset.insertion <- truthset_ground[truthset_ground[,1]=="insertion",]

tool_sets <- c("DeepVariant","DELLY","FermiKit","GATK_HC","Pindel","Platypus","Strelka2","VarScan")
data_sets <- c("100bp_5X_500","100bp_30X_500","100bp_60X_500","250bp_30X_500","250bp_30X_800")

for (coverage in data_sets)
{
  print(coverage)
  precision_deletion <- vector()
  recall_deletion <- vector()
  precision_insertion <- vector()
  recall_insertion <- vector()
  for (tool in tool_sets)
  {
    print(tool)
    path_tool <- paste0("/data/epouta1/B18010_indel_tool_evaluation/Semi-simulated_chr2/Other_tools/downstream_analysis/3_Results_evaluation/",
                        coverage,"/",tool,"/")
    D <- results_calculate(truthset.deletion,truthset.insertion,path_tool)
    precision_deletion <- rbind(precision_deletion,D[1,])
    recall_deletion <- rbind(recall_deletion,D[2,])
    precision_insertion <- rbind(precision_insertion,D[3,])
    recall_insertion <- rbind(recall_insertion,D[4,])
  }
  precision_deletion <- cbind(tool_sets,precision_deletion)
  recall_deletion <- cbind(tool_sets,recall_deletion)
  precision_insertion <- cbind(tool_sets,precision_insertion)
  recall_insertion <- cbind(tool_sets,recall_insertion)
  
  rowname_matrix_D <- c("Callers","-1","-2","-3","-4","-5")
  precision_deletion <- rbind(rowname_matrix_D,precision_deletion)
  recall_deletion <- rbind(rowname_matrix_D,recall_deletion)
  rowname_matrix_I <- c("Callers","1","2","3","4","5")
  precision_insertion <- rbind(rowname_matrix_I,precision_insertion)
  recall_insertion <- rbind(rowname_matrix_I,recall_insertion)
  
  path_dataset <- paste0("/data/epouta1/B18010_indel_tool_evaluation/Semi-simulated_chr2/Other_tools/downstream_analysis/3_Results_evaluation/",coverage,"/")
  precision_D_name <- paste0(path_dataset,"Deletion_Precision_Genotype_short.txt")
  #precision_D_name <- paste0(path_dataset,"Deletion_Precision_short.txt")
  write.table(precision_deletion,precision_D_name,row.names = F,col.names = F,quote = F)
  recall_D_name <- paste0(path_dataset,"Deletion_Recall_Genotype_short.txt")
  #recall_D_name <- paste0(path_dataset,"Deletion_Recall_short.txt")
  write.table(recall_deletion,recall_D_name,row.names = F,col.names = F,quote = F)
  precision_I_name <- paste0(path_dataset,"Insertion_Precision_Genotype_short.txt")
  #precision_I_name <- paste0(path_dataset,"Insertion_Precision_short.txt")
  write.table(precision_insertion,precision_I_name,row.names = F,col.names = F,quote = F)
  recall_I_name <- paste0(path_dataset,"Insertion_Recall_Genotype_short.txt")
  #recall_I_name <- paste0(path_dataset,"Insertion_Recall_short.txt") 
  write.table(recall_insertion,recall_I_name,row.names = F,col.names = F,quote = F)
}




























































