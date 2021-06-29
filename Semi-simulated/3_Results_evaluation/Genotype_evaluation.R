calculate_genotype <- function(get_path,truthset)
{
  # TP result
  deletion_eval_name <- paste0(get_path,"deletion.txt")
  insertion_eval_name <- paste0(get_path,"insertion.txt")
  deletion_eval <- read.table(deletion_eval_name,header = F)
  deletion_eval <- unique(deletion_eval)
  insertion_eval <- read.table(insertion_eval_name,header = F)
  insertion_eval <- unique(insertion_eval)
  
  deletion_eval_pass <- deletion_eval[abs(as.numeric(deletion_eval[,1])-as.numeric(deletion_eval[,4]))<=10,]
  deletion_eval_pass <- deletion_eval_pass[abs(as.numeric(deletion_eval_pass[,1])-as.numeric(deletion_eval_pass[,4]))<=
                                             as.numeric(deletion_eval_pass[,5])*0.1,]
  deletion_eval_pass[deletion_eval_pass[,3]=="1|0",3] <- "0/1"
  deletion_eval_pass[deletion_eval_pass[,3]=="0|1",3] <- "0/1"
  deletion_eval_pass[deletion_eval_pass[,3]=="1|1",3] <- "1/1"
  deletion_eval_pass[deletion_eval_pass[,3]=="1/0",3] <- "0/1"
  deletion_eval_pass2 <- deletion_eval_pass[as.character(deletion_eval_pass[,3])==as.character(deletion_eval_pass[,6]),]
  
  insertion_eval_pass <- insertion_eval[abs(as.numeric(insertion_eval[,1])-as.numeric(insertion_eval[,4]))<=10,]
  insertion_eval_pass <- insertion_eval_pass[abs(as.numeric(insertion_eval_pass[,1])-as.numeric(insertion_eval_pass[,4]))<=
                                               as.numeric(insertion_eval_pass[,5])*0.1,]
  insertion_eval_pass[insertion_eval_pass[,3]=="1|0",3] <- "0/1"
  insertion_eval_pass[insertion_eval_pass[,3]=="0|1",3] <- "0/1"
  insertion_eval_pass[insertion_eval_pass[,3]=="1|1",3] <- "1/1"
  insertion_eval_pass[insertion_eval_pass[,3]=="1/0",3] <- "0/1"
  insertion_eval_pass2 <- insertion_eval_pass[as.character(insertion_eval_pass[,3])==as.character(insertion_eval_pass[,6]),]

  indel_eval_pass2 <- rbind(deletion_eval_pass2,insertion_eval_pass2)
  indel_eval_pass_homo <- indel_eval_pass2[indel_eval_pass2[,3]=="1/1",]
  indel_eval_pass_heter <- indel_eval_pass2[indel_eval_pass2[,3]=="0/1",]
  
  # tool set
  deletion_tool_name <- paste0(get_path,"deletion_result.txt")
  deletion_tool <- read.table(deletion_tool_name,header = F)
  deletion_tool <- unique(deletion_tool)
  deletion_tool[deletion_tool[,3]=="1|0",3] <- "0/1"
  deletion_tool[deletion_tool[,3]=="0|1",3] <- "0/1"
  deletion_tool[deletion_tool[,3]=="1|1",3] <- "1/1"
  deletion_tool[deletion_tool[,3]=="1/0",3] <- "0/1"
  deletion_tool[deletion_tool[,3]=="0|0",3] <- "0/0"
  deletion_tool[deletion_tool[,3]=="1|2",3] <- "1/2"
  deletion_tool[deletion_tool[,3]=="2|1",3] <- "1/2"
  deletion_tool[deletion_tool[,3]=="2/1",3] <- "1/2"
  
  insertion_tool_name <- paste0(get_path,"insertion_result.txt")
  insertion_tool <- read.table(insertion_tool_name,header = F)
  insertion_tool <- unique(insertion_tool)
  insertion_tool[insertion_tool[,3]=="1|0",3] <- "0/1"
  insertion_tool[insertion_tool[,3]=="0|1",3] <- "0/1"
  insertion_tool[insertion_tool[,3]=="1|1",3] <- "1/1"
  insertion_tool[insertion_tool[,3]=="1/0",3] <- "0/1"
  insertion_tool[insertion_tool[,3]=="0|0",3] <- "0/0"
  insertion_tool[insertion_tool[,3]=="1|2",3] <- "1/2"
  insertion_tool[insertion_tool[,3]=="2|1",3] <- "1/2"
  insertion_tool[insertion_tool[,3]=="2/1",3] <- "1/2"
  
  indel_tool <- rbind(deletion_tool,insertion_tool)
  indel_tool_homo <- indel_tool[indel_tool[,3]=="1/1",]
  indel_tool_heter <- indel_tool[indel_tool[,3]=="0/1" | indel_tool[,3]=="1/2" ,]
  
  # pass position match and size match but failed with genotype match
  indel_eval_pass1 <- rbind(deletion_eval_pass,insertion_eval_pass)
  indel_tool_fail <- indel_eval_pass1[indel_eval_pass1[,3]=="0/0",]
  
  # result
  homo_precision <- dim(indel_eval_pass_homo)[1]/dim(indel_tool_homo)[1]
  heter_precision <- dim(indel_eval_pass_heter)[1]/dim(indel_tool_heter)[1]
  geno_fail <- dim(indel_tool_fail)[1]/dim(indel_tool)[1]
  result <- c(homo_precision,heter_precision,geno_fail)
  
  return(result)
}

tool_sets <- c("DeepVariant","DELLY","FermiKit","GATK_HC","Pindel","Platypus","Strelka2","VarScan")
data_sets <- c("5X","30X","30X_250bp","60X")

truthset_ground <- read.table("variants_truthset.txt")
new.position <- as.numeric(as.character(truthset_ground[,2]))
truthset_ground <- cbind(truthset_ground,new.position)
truthset_ground[truthset_ground[,5]=="1/0",5] <- "0/1"

for (coverage in data_sets)
{
  print(coverage)
  genotype_accuracy <- vector()
  for (tool in tool_sets)
  {
    print(tool)
    path_tool <- paste0("./",coverage,"/",tool,"/")
    D <- calculate_genotype(path_tool,truthset_ground)
    genotype_accuracy <- rbind(genotype_accuracy,D)
  }
  genotype_accuracy <- cbind(tool_sets,genotype_accuracy)
  
  rowname_matrix_D <- c("Callers","homo_precision","heter_precision","failed_genotype")
  genotype_accuracy <- rbind(rowname_matrix_D,genotype_accuracy)
  
  path_dataset <- paste0("./",coverage,"/")
  genotype_accuracy_name <- paste0(path_dataset,"Genotype_accuracy.txt")
  write.table(genotype_accuracy,genotype_accuracy_name,row.names = F,col.names = F,quote = F)
}














































































