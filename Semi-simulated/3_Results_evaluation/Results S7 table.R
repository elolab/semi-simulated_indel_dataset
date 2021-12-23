options(scipen = 999)

results_calculate <- function(TRUTH,get_path)
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
  
  tools_pass <- rbind(deletion_eval_pass,insertion_eval_pass)
  
  deletion_tool_name <- paste0(get_path,"deletion_result.txt")
  insertion_tool_name <- paste0(get_path,"insertion_result.txt")
  deletion_tool <- read.table(deletion_tool_name,header = F)
  deletion_tool <- unique(deletion_tool)
  insertion_tool <- read.table(insertion_tool_name,header = F)
  insertion_tool <- unique(insertion_tool)
  tools_detected <- rbind(deletion_tool,insertion_tool)
  
  tools_pass_1 <- tools_pass[tools_pass[,3]>=1 & tools_pass[,3]<50,]
  tools_pass_50 <- tools_pass[tools_pass[,3]>=50 & tools_pass[,3]<5000,]
  tools_detected_1 <- tools_detected[tools_detected[,3]>=1 & tools_detected[,3]<50,]
  tools_detected_50 <- tools_detected[tools_detected[,3]>=50 & tools_detected[,3]<5000,]
  TRUTH_1 <- TRUTH[TRUTH[,3]>=1 & TRUTH[,3]<50,]
  TRUTH_50 <- TRUTH[TRUTH[,3]>=50 & TRUTH[,3]<5000,]
      
  precision_1 <- dim(tools_pass_1)[1]/dim(tools_detected_1)[1]
  recall_1 <- dim(tools_pass_1)[1]/dim(TRUTH_1)[1]
  F1_score_1 <- (2*(precision_1*recall_1))/(precision_1+recall_1)
  
  precision_50 <- dim(tools_pass_50)[1]/dim(tools_detected_50)[1]
  recall_50 <- dim(tools_pass_50)[1]/dim(TRUTH_50)[1]
  F1_score_50 <- (2*(precision_50*recall_50))/(precision_50+recall_50)
  
  TP_1 <- dim(tools_pass_1)[1]
  FP_1 <- dim(tools_detected_1)[1]-dim(tools_pass_1)[1]
  FN_1 <- dim(TRUTH_1)[1]-dim(tools_pass_1)[1]
  TP_50 <- dim(tools_pass_50)[1]
  FP_50 <- dim(tools_detected_50)[1]-dim(tools_pass_50)[1]
  FN_50 <- dim(TRUTH_50)[1]-dim(tools_pass_50)[1]
  
  Results_summary <- c(TP_1,FP_1,FN_1,precision_1,recall_1,F1_score_1,
                       TP_50,FP_50,FN_50,precision_50,recall_50,F1_score_50)
  
  return(Results_summary)
}

setwd("/3_Results_evaluation/")
truthset_ground <- read.table("chr1_chr2_variants_truthset.txt")
new.position <- as.numeric(as.character(truthset_ground[,2]))
truthset_ground <- cbind(truthset_ground,new.position)
truthset_ground[truthset_ground[,5]=="1/0",5] <- "0/1"

tool_sets <- c("DeepVariant","DELLY","FermiKit","GATK_HC","Pindel","Platypus","Strelka2","VarScan")
data_sets <- c("100bp_5X_500","100bp_30X_500","100bp_60X_500","250bp_30X_500","250bp_30X_800")
for (coverage in data_sets)
{
  print(coverage)
  Results_all <- vector()
  for (tool in tool_sets)
  {
    print(tool)
    path_tool <- paste0("/3_Results_evaluation/",
                        coverage,"/",tool,"/")
    D <- results_calculate(truthset_ground,path_tool)
    Results_all <- rbind(Results_all,D[c(1,2,3,4,5,6)])
    Results_all <- rbind(Results_all,D[c(7,8,9,10,11,12)])
  }
  tool_sets2 <- c("DeepVariant","DeepVariant2","DELLY","DELLY2","FermiKit","FermiKit2","GATK_HC","GATK_HC2",
                  "Pindel","Pindel2","Platypus","Platypus2","Strelka2","Strelka22","VarScan","VarScan2")
  Results_all <- cbind(tool_sets2,Results_all)
  
  rowname_matrix_D <- c("Callers","TP","FP","FN","Precision","Recall","F1_score")
  Results_all <- rbind(rowname_matrix_D,Results_all)
  
  path_dataset <- paste0("/3_Results_evaluation/",coverage,"/")
  Result_D_name <- paste0(path_dataset,"Result_all.txt")
  write.table(Results_all, Result_D_name,row.names = F,col.names = F,quote = F)
}

























































