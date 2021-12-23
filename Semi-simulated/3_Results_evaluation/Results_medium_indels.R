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
  indel_eval_pass <- rbind(deletion_eval_pass,insertion_eval_pass)
  
  deletion_tool_name <- paste0(get_path,"deletion_result.txt")
  insertion_tool_name <- paste0(get_path,"insertion_result.txt")
  deletion_tool <- read.table(deletion_tool_name,header = F)
  deletion_tool <- unique(deletion_tool)
  insertion_tool <- read.table(insertion_tool_name,header = F)
  insertion_tool <- unique(insertion_tool)
  tool_indel <- rbind(deletion_tool,insertion_tool)
  
  truth_indel <- rbind(T_deletion,T_insertion)
  
  interval_1 <- c(30)
  interval_2 <- c(70)
  
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
  C <- parse_length(indel_eval_pass,truth_indel,tool_indel,interval_1,interval_2)
  D <- rbind(A,B)
  D <- rbind(D,C)
  return(D)
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
  results_indel <- vector()
  for (tool in tool_sets)
  {
    print(tool)
    path_tool <- paste0("/data/epouta1/B18010_indel_tool_evaluation/Semi-simulated_chr2/Other_tools/downstream_analysis/3_Results_evaluation/",
                        coverage,"/",tool,"/")
    D <- results_calculate(truthset.deletion,truthset.insertion,path_tool)
    results_indel <- rbind(results_indel,D)
  }
  tool_sets2 <- c("DeepVariant_D","DeepVariant_I","DeepVariant_Indel","DELLY_D","DELLY_I","DELLY_Indel",
                  "FermiKit_D","FermiKit_I","FermiKit_Indel","GATK_HC_D","GATK_HC_I","GATK_HC_Indel",
                  "Pindel_D","Pindel_I","Pindel_Indel","Platypus_D","Platypus_I","Platypus_Indel",
                  "Strelka2_D","Strelka2_I","Strelka2_Indel","VarScan_D","VarScan_I","VarScan_Indel")
  results_indel <- cbind(tool_sets2,results_indel)
  
  rowname_matrix <- c("Callers","30-70_TP","30-70_FP","30-70_FN","30-70_Precision","30-70_Recall","30-70_F1_score")
  results_indel <- rbind(rowname_matrix,results_indel)
  
  path_dataset <- paste0("/data/epouta1/B18010_indel_tool_evaluation/Semi-simulated_chr2/Other_tools/downstream_analysis/3_Results_evaluation/",coverage,"/")
  results_indel_name <- paste0(path_dataset,"Indel_35_65.txt")
  write.table(results_indel,results_indel_name,row.names = F,col.names = F,quote = F)
}


path_tool <- paste0("/data/epouta1/B18010_indel_tool_evaluation/Semi-simulated_chr2/Other_tools/downstream_analysis/3_Results_evaluation/",
                    "100bp_60X_500","/","FermiKit","/")
T_deletion <- truthset.deletion
T_insertion <- truthset.insertion
get_path <- path_tool