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
  
  interval_1 <- c(1,20,50,200,500)
  interval_2 <- c(20,50,200,500,5000)
  
  parse_length <- function(P_input_get,truth_set,query_set,interval_1,interval_2)
  {
    results_S <- vector()
    for(i in 1:length(interval_1))
    {
      Results_tool <- P_input_get[as.numeric(as.character(P_input_get[,3])) >= as.numeric(interval_1[i]) 
                                  & as.numeric(as.character(P_input_get[,3])) < as.numeric(interval_2[i]),]
      Results_truth <- P_input_get[as.numeric(as.character(P_input_get[,7])) >= as.numeric(interval_1[i]) 
                                   & as.numeric(as.character(P_input_get[,7])) < as.numeric(interval_2[i]),]
      Raw_tools <- query_set[as.numeric(as.character(query_set[,3])) >= as.numeric(interval_1[i]) 
                             & as.numeric(as.character(query_set[,3])) < as.numeric(interval_2[i]),]
      Raw_truth <- truth_set[as.numeric(as.character(truth_set[,3])) >= as.numeric(interval_1[i]) 
                             & as.numeric(as.character(truth_set[,3])) < as.numeric(interval_2[i]),]
      
      precision <-dim(Results_tool)[1]/dim(Raw_tools)[1]
      recall <- dim(Results_truth)[1]/dim(Raw_truth)[1]
      F_score <- (2*precision*recall)/(precision+recall)
      
      results_S <- c(results_S,dim(Results_tool)[1],dim(Raw_tools)[1]-dim(Results_tool)[1],dim(Raw_truth)[1]-dim(Results_truth)[1],
                     precision,recall,F_score)
    }
    return(results_S)
  }
  A <- parse_length(deletion_eval_pass,T_deletion, deletion_tool,interval_1,interval_2)
  B <- parse_length(insertion_eval_pass,T_insertion, insertion_tool,interval_1,interval_2)
  C <- rbind(A,B)
  return(C)
}

setwd("/3_Results_evaluation/")
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
  results_deletion <- vector()
  results_insertion <- vector()
  for (tool in tool_sets)
  {
    print(tool)
    path_tool <- paste0("/3_Results_evaluation/",
                        coverage,"/",tool,"/")
    D <- results_calculate(truthset.deletion,truthset.insertion,path_tool)
    results_deletion <- rbind(results_deletion,D[1,])
    results_insertion <- rbind(results_insertion,D[2,])
  }
  results_deletion <- cbind(tool_sets,results_deletion)
  results_insertion <- cbind(tool_sets,results_insertion)
  
  rowname_matrix <- c("Callers","1-20_TP","1-20_FP","1-20_FN","1-20_Precision","1-20_Recall","1-20_F1_score",
                        "20-50_TP","20-50_FP","20-50_FN","20-50_Precision","20-50_Recall","20-50_F1_score",
                        "50-200_TP","50-200_FP","50-200_FN","50-200_Precision","50-200_Recall","50-200_F1_score",
                        "200-500_TP","200-500_FP","200-500_FN","200-500_Precision","200-500_Recall","200-500_F1_score",
                        ">500_TP",">500_FP",">500_FN",">500_Precision",">500_Recall",">500_F1_score")
  results_deletion <- rbind(rowname_matrix,results_deletion)
  results_insertion <- rbind(rowname_matrix,results_insertion)
  
  path_dataset <- paste0("/3_Results_evaluation/",coverage,"/")
  results_D_name <- paste0(path_dataset,"Deletion_details_Genotype.txt")
  write.table(results_deletion,results_D_name,row.names = F,col.names = F,quote = F)
  results_I_name <- paste0(path_dataset,"Insertion_details_Genotype.txt")
  write.table(results_insertion,results_I_name,row.names = F,col.names = F,quote = F)
}

























































