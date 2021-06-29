options(scipen = 999)

results_calculate <- function(T_deletion,T_insertion,get_path)
{
  deletion_eval_name <- paste0(get_path,"deletion.txt")
  insertion_eval_name <- paste0(get_path,"insertion.txt")
  deletion_eval <- read.table(deletion_eval_name,header = F)
  deletion_eval <- unique(deletion_eval)
  insertion_eval <- read.table(insertion_eval_name,header = F)
  insertion_eval <- unique(insertion_eval)
  
  deletion_eval_pass <- deletion_eval[abs(as.numeric(deletion_eval[,1])-as.numeric(deletion_eval[,4]))<=
                                             as.numeric(deletion_eval[,5])*0.1,]
  deletion_eval_pass <- deletion_eval_pass[abs(as.numeric(deletion_eval_pass[,1])-
                                                 as.numeric(deletion_eval_pass[,4]))<=50,]
  deletion_eval_pass[deletion_eval_pass[,3]=="1|0",3] <- "0/1"
  deletion_eval_pass[deletion_eval_pass[,3]=="0|1",3] <- "0/1"
  deletion_eval_pass[deletion_eval_pass[,3]=="1|1",3] <- "1/1"
  deletion_eval_pass[deletion_eval_pass[,3]=="1/0",3] <- "0/1"
  #deletion_eval_pass <- deletion_eval_pass[as.character(deletion_eval_pass[,3])==as.character(deletion_eval_pass[,6]),]
  
  insertion_eval_pass <- insertion_eval[abs(as.numeric(insertion_eval[,1])-as.numeric(insertion_eval[,4]))<=
                                               as.numeric(insertion_eval[,5])*0.1,]
  insertion_eval_pass <- insertion_eval_pass[abs(as.numeric(insertion_eval_pass[,1])-
                                                   as.numeric(insertion_eval_pass[,4]))<=50,]
  insertion_eval_pass[insertion_eval_pass[,3]=="1|0",3] <- "0/1"
  insertion_eval_pass[insertion_eval_pass[,3]=="0|1",3] <- "0/1"
  insertion_eval_pass[insertion_eval_pass[,3]=="1|1",3] <- "1/1"
  insertion_eval_pass[insertion_eval_pass[,3]=="1/0",3] <- "0/1"
  #insertion_eval_pass <- insertion_eval_pass[as.character(insertion_eval_pass[,3])==as.character(insertion_eval_pass[,6]),]
  
  deletion_tool_name <- paste0(get_path,"deletion_result.txt")
  insertion_tool_name <- paste0(get_path,"insertion_result.txt")
  deletion_tool <- read.table(deletion_tool_name,header = F)
  deletion_tool <- unique(deletion_tool)
  insertion_tool <- read.table(insertion_tool_name,header = F)
  insertion_tool <- unique(insertion_tool)
  
  interval_1 <- c(1,20,50,200,500)
  interval_2 <- c(20,50,200,500,10000)
  
  parse_length <- function(P_input_get,truth_set,query_set,interval_1,interval_2)
  {
    precision <- vector()
    recall <- vector()
    for(i in 1:length(interval_1))
    {
      Resutls_tool <- P_input_get[as.numeric(as.character(P_input_get[,2])) >= as.numeric(interval_1[i]) 
                                  & as.numeric(as.character(P_input_get[,2])) < as.numeric(interval_2[i]),]
      Results_truth <- P_input_get[as.numeric(as.character(P_input_get[,5])) >= as.numeric(interval_1[i]) 
                                   & as.numeric(as.character(P_input_get[,5])) < as.numeric(interval_2[i]),]
      Raw_tools <- query_set[as.numeric(as.character(query_set[,2])) >= as.numeric(interval_1[i]) 
                             & as.numeric(as.character(query_set[,2])) < as.numeric(interval_2[i]),]
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

truthset_ground <- read.table("variants_truthset.txt")
new.position <- as.numeric(as.character(truthset_ground[,2]))
truthset_ground <- cbind(truthset_ground,new.position)
truthset_ground[truthset_ground[,5]=="1/0",5] <- "0/1"
truthset.deletion <- truthset_ground[truthset_ground[,1]=="deletion",]
truthset.insertion <- truthset_ground[truthset_ground[,1]=="insertion",]

tool_sets <- c("DeepVariant","DELLY","FermiKit","GATK_HC","Pindel","Platypus","Strelka2","VarScan")
data_sets <- c("5X","30X","30X_250bp","60X")

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
    path_tool <- paste0("./",coverage,"/",tool,"/")
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
  
  path_dataset <- paste0("./",coverage,"/")
  #precision_D_name <- paste0(path_dataset,"Deletion_Precision_Genotype.txt")
  precision_D_name <- paste0(path_dataset,"Deletion_Precision.txt")
  write.table(precision_deletion,precision_D_name,row.names = F,col.names = F,quote = F)
  #recall_D_name <- paste0(path_dataset,"Deletion_Recall_Genotype.txt")
  recall_D_name <- paste0(path_dataset,"Deletion_Recall.txt")
  write.table(recall_deletion,recall_D_name,row.names = F,col.names = F,quote = F)
  #precision_I_name <- paste0(path_dataset,"Insertion_Precision_Genotype.txt")
  precision_I_name <- paste0(path_dataset,"Insertion_Precision.txt")
  write.table(precision_insertion,precision_I_name,row.names = F,col.names = F,quote = F)
  #recall_I_name <- paste0(path_dataset,"Insertion_Recall_Genotype.txt")
  recall_I_name <- paste0(path_dataset,"Insertion_Recall.txt") 
  write.table(recall_insertion,recall_I_name,row.names = F,col.names = F,quote = F)
}




























































