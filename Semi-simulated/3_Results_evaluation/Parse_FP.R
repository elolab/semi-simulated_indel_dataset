options(scipen = 999)
false_positive <- function(get_path)
{
  deletion_eval_name <- paste0(get_path,"deletion.txt")
  insertion_eval_name <- paste0(get_path,"insertion.txt")
  deletion_eval <- read.table(deletion_eval_name,header = F)
  deletion_eval <- unique(deletion_eval)
  insertion_eval <- read.table(insertion_eval_name,header = F)
  insertion_eval <- unique(insertion_eval)
  indel_eval <- rbind(deletion_eval,insertion_eval)
  indel_eval_pass <- indel_eval[abs(as.numeric(indel_eval[,1])-as.numeric(indel_eval[,4]))<=10,]
  indel_eval_pass <- indel_eval[abs(as.numeric(indel_eval[,1])-as.numeric(indel_eval[,4]))<=
                                  as.numeric(indel_eval[,5])*0.1,]
  indel_eval_pass[indel_eval_pass[,3]=="1|0",3] <- "0/1"
  indel_eval_pass[indel_eval_pass[,3]=="0|1",3] <- "0/1"
  indel_eval_pass[indel_eval_pass[,3]=="1|1",3] <- "1/1"
  indel_eval_pass <- indel_eval_pass[as.character(indel_eval_pass[,3]) == as.character(indel_eval_pass[,6]),]
  
  deletion_tool_name <- paste0(get_path,"deletion_result.txt")
  deletion_tool <- read.table(deletion_tool_name,header = F)
  deletion_tool <- unique(deletion_tool)
  insertion_tool_name <- paste0(get_path,"insertion_result.txt")
  insertion_tool <- read.table(insertion_tool_name,header = F)
  insertion_tool <- unique(insertion_tool)
  indel_tool <- rbind(deletion_tool,insertion_tool)
  
  FP_row <- setdiff(indel_tool[,1],indel_eval_pass[,1])
  FP_vcf <- indel_tool[indel_tool[,1] %in% FP_row,]
  FP_vcf <- FP_vcf[!duplicated(FP_vcf),]
  FP_vcf <- cbind(rep("chr1",dim(FP_vcf)[1]),as.character(FP_vcf[,1]),as.numeric(as.character(FP_vcf[,1]))+as.numeric(as.character(FP_vcf[,2])))
  FP_vcf <- as.data.frame(FP_vcf)
  FP_vcf_name <- paste0(get_path,"variants_FP.vcf")
  write.table(FP_vcf,FP_vcf_name,row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
}

tool_sets <- c("DeepVariant","DELLY","FermiKit","GATK_HC","Pindel","Platypus", "Strelka2","VarScan")
data_sets <- c("5X","30X","30X_250bp","60X")
for (coverage in data_sets)
{
  print(coverage)
  genotype_accuracy <- vector()
  for (tool in tool_sets)
  {
    print(tool)
    path_tool <- paste0("./",coverage,"/",tool,"/")
    false_positive(path_tool)
  }
}
################################################################################################
# BedTool
################################################################################################
FP_category <- function(get_path)
{
  repeat_FP_name <- paste0(get_path,"repeat_FP.vcf")
  repeat.FP <- read.table(repeat_FP_name)
  repeat.FP <- repeat.FP[!duplicated(repeat.FP),]
  
  FP_vcf_name <- paste0(get_path,"variants_FP.vcf")
  FP_vcf <- read.table(FP_vcf_name)
  FP_vcf <- FP_vcf[!duplicated(FP_vcf),]
  FP_vcf2 <- FP_vcf[!(FP_vcf[,2] %in% repeat.FP[,2]),]
  
  item <- c(dim(FP_vcf)[1],dim(repeat.FP)[1],dim(FP_vcf2)[1])
  return(item)
}

tool_sets <- c("DeepVariant","DELLY","FermiKit","GATK_HC","Pindel","Platypus","Strelka2","VarScan")
data_sets <- c("5X","30X","30X_250bp","60X")
for (coverage in data_sets)
{
  print(coverage)
  FP_file <- vector()
  for (tool in tool_sets)
  {
    print(tool)
    path_tool <- paste0("./",coverage,"/",tool,"/")
    FP_term <- FP_category(path_tool)
    FP_file <- rbind(FP_file,FP_term)
  }
  rownames(FP_file) <- tool_sets
  colnames(FP_file) <- c("Total_FP","simpleRepeat_FP","Rest_FP")
  FP_file_name <- paste0("./",coverage,"/","FP_summary.txt")
  write.table(FP_file,FP_file_name,row.names = T,col.names = T,quote = FALSE, sep = "\t")
}
#########################################################################################################



























