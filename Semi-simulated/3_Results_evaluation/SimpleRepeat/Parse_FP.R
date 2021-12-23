options(scipen = 999)
################################################################################################
false_positive <- function(get_path)
{
  deletion_eval_name <- paste0(get_path,"deletion.txt")
  insertion_eval_name <- paste0(get_path,"insertion.txt")
  deletion_eval <- read.table(deletion_eval_name,header = F)
  deletion_eval <- unique(deletion_eval)
  insertion_eval <- read.table(insertion_eval_name,header = F)
  insertion_eval <- unique(insertion_eval)
  indel_eval_pre <- rbind(deletion_eval,insertion_eval)
  FP_vcf_all <- vector()
  
  deletion_tool_name <- paste0(get_path,"deletion_result.txt")
  deletion_tool_pre <- read.table(deletion_tool_name,header = F)
  insertion_tool_name <- paste0(get_path,"insertion_result.txt")
  insertion_tool_pre <- read.table(insertion_tool_name,header = F)
  
  chr_pick <- c("chr1","chr2")
  for (chr in chr_pick)
  {
    indel_eval <- indel_eval_pre[indel_eval_pre[,1]==chr,]
    indel_eval_pass <- indel_eval[abs(as.numeric(indel_eval[,2])-as.numeric(indel_eval[,6]))<=10,]
    indel_eval_pass <- indel_eval[abs(as.numeric(indel_eval[,2])-as.numeric(indel_eval[,6]))<=
                                    as.numeric(indel_eval[,7])*0.1,]
    indel_eval_pass[indel_eval_pass[,4]=="1|0",4] <- "0/1"
    indel_eval_pass[indel_eval_pass[,4]=="0|1",4] <- "0/1"
    indel_eval_pass[indel_eval_pass[,4]=="1|1",4] <- "1/1"
    indel_eval_pass[indel_eval_pass[,4]=="1/0",4] <- "0/1"
    indel_eval_pass <- indel_eval_pass[as.character(indel_eval_pass[,4]) == as.character(indel_eval_pass[,8]),]
    
    deletion_tool <- deletion_tool_pre[deletion_tool_pre[,1]==chr,]
    deletion_tool <- unique(deletion_tool)
    insertion_tool <- insertion_tool_pre[insertion_tool_pre[,1]==chr,]
    insertion_tool <- unique(insertion_tool)
    indel_tool <- rbind(deletion_tool,insertion_tool)
    
    FP_row <- setdiff(indel_tool[,2],indel_eval_pass[,2])
    FP_vcf <- indel_tool[indel_tool[,2] %in% FP_row,]
    FP_vcf <- FP_vcf[!duplicated(FP_vcf),]
    FP_vcf <- cbind(rep(chr,dim(FP_vcf)[1]),as.character(FP_vcf[,2]),as.numeric(as.character(FP_vcf[,2]))+as.numeric(as.character(FP_vcf[,3])))
    FP_vcf <- as.data.frame(FP_vcf)
    FP_vcf_all <- rbind(FP_vcf_all,FP_vcf)
  }
  FP_vcf_name <- paste0(get_path,"variants_FP.vcf")
  write.table(FP_vcf_all,FP_vcf_name,row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
}

setwd("/3_Results_evaluation")
tool_sets <- c("DeepVariant","DELLY","FermiKit","GATK_HC","Pindel","Platypus", "Strelka2","VarScan")
data_sets <- c("100bp_5X_500","100bp_30X_500","100bp_60X_500","250bp_30X_500","250bp_30X_800")
for (coverage in data_sets)
{
  print(coverage)
  genotype_accuracy <- vector()
  for (tool in tool_sets)
  {
    print(tool)
    path_tool <- paste0("/3_Results_evaluation/",
                        coverage,"/",tool,"/")
    false_positive(path_tool)
  }
}
################################################################################################
# Then run bedtools comment lines
################################################################################################
FP_category <- function(get_path)
{
  repeat_FP_name <- paste0(get_path,"repeat_FP.bed")
  repeat.FP <- read.table(repeat_FP_name)
  repeat.FP <- repeat.FP[!duplicated(repeat.FP),]
  repeat.FP <- repeat.FP[repeat.FP[,3]-repeat.FP[,2]<=5000,]
  repeat.FP.id <- paste0(repeat.FP[,1],repeat.FP[,2])
  repeat.FP <- cbind(repeat.FP,repeat.FP.id)
  
  FP_vcf_name <- paste0(get_path,"variants_FP.vcf")
  FP_vcf <- read.table(FP_vcf_name)
  FP_vcf <- FP_vcf[!duplicated(FP_vcf),]
  FP_vcf <- FP_vcf[FP_vcf[,3]-FP_vcf[,2]<=5000,]
  FP_vcf.id <- paste0(FP_vcf[,1],FP_vcf[,2])
  FP_vcf <- cbind(FP_vcf,FP_vcf.id)
  FP_vcf2 <- FP_vcf[!(FP_vcf[,4] %in% repeat.FP[,4]),]
  
  item <- c(dim(FP_vcf)[1],dim(repeat.FP)[1],dim(FP_vcf2)[1])
  return(item)
}

setwd("/3_Results_evaluation/")
tool_sets <- c("DeepVariant","DELLY","FermiKit","GATK_HC","Pindel","Platypus","Strelka2","VarScan")
data_sets <- c("100bp_5X_500","100bp_30X_500","100bp_60X_500","250bp_30X_500","250bp_30X_800")
#data_sets <- c("100bp_5X_500")
for (coverage in data_sets)
{
  print(coverage)
  FP_file <- vector()
  for (tool in tool_sets)
  {
    print(tool)
    path_tool <- paste0("/3_Results_evaluation/",
                        coverage,"/",tool,"/")
    FP_term <- FP_category(path_tool)
    FP_file <- rbind(FP_file,FP_term)
  }
  rownames(FP_file) <- tool_sets
  colnames(FP_file) <- c("Total_FP","simpleRepeat_FP","Rest_FP")
  FP_file_name <- paste0("/3_Results_evaluation/",
                         coverage,"/","FP_summary.txt")
  write.table(FP_file,FP_file_name,row.names = T,col.names = T,quote = FALSE, sep = "\t")
}
#########################################################################################################























