generate_tool_results <- function(location_path)
{
  fermikit_sv_pre <- read.table(paste0(location_path,"fermikit.sv.vcf"))
  # FermiKit only has 3 SVTYPE: INS,DEL,COMPLEX
  fermikit_sv_ins_all <- vector()
  fermikit_sv_del_all <- vector()
  # get insertion and deletion from flt result
  raw_input_pre <- read.table(paste0(location_path,"out2.recode.vcf"))
  fermikit_flt_pre <- read.table(paste0(location_path,"fermikit.flt.recode.vcf"))
  
  chr_pick <- c("chr1","chr2")
  for (chr in chr_pick)
  {
    fermikit_sv <- fermikit_sv_pre[fermikit_sv_pre[,1]==chr,]
    raw_input <- raw_input_pre[raw_input_pre[,1]==chr,]
    fermikit_flt <- fermikit_flt_pre[fermikit_flt_pre[,1]==chr,]
    
    fermikit_sv_ins <- vector()
    fermikit_sv_del <- vector()
    
    # split indels from SV result
    # summary(as.numeric(fermikit_sv_ins[,2])), min_length is 104
    # summary(as.numeric(fermikit_sv_del[,2])), min_length is 88
    for (i in 1: dim(fermikit_sv)[1])
    {
      item <- vector()
      input_info <- strsplit(as.character(fermikit_sv[i,8]),";")[[1]]
      input_type <- input_info[grep("SVTYPE=",input_info)]
      input_len <- input_info[grep("SVLEN=",input_info)]
      input_LEN <- substr(as.character(input_len),7,nchar(input_len))
      if (input_type == "SVTYPE=INS")
      {
        item <- c(chr,fermikit_sv[i,2],input_LEN,"0/0")
        fermikit_sv_ins <- rbind(fermikit_sv_ins,item)  # first column is position, second column is SV length
      }
      else if (input_type == "SVTYPE=DEL")
      {
        item <- c(chr,fermikit_sv[i,2],input_LEN,"0/0")
        fermikit_sv_del <- rbind(fermikit_sv_del,item)  # first column is position, second column is SV length
      }
    }
    
    Bio_allele <- raw_input[grepl(",",as.character(raw_input[,5])),]
    Split_allele <- vector()
    for (i in 1:dim(Bio_allele)[1])
    {
      head <- Bio_allele[i,1:4]
      trail <- Bio_allele[i,6:10]
      V5 <- strsplit(as.character(Bio_allele[i,5]), ",")[[1]][1]
      Record_1 <- cbind(head,V5,trail)
      V5 <- strsplit(as.character(Bio_allele[i,5]), ",")[[1]][2]
      Record_2 <- cbind(head,V5,trail)
      Split_allele <- rbind(Split_allele,Record_1)
      Split_allele <- rbind(Split_allele,Record_2)
    }
    
    fermikit_flt <- rbind(fermikit_flt,Split_allele)
    fermikit_flt <- fermikit_flt[order(as.numeric(fermikit_flt[,2])),]
    
    rownames(fermikit_flt) <- seq(length=nrow(fermikit_flt))# reset row name
    fermikit_flt_ins <- fermikit_flt[nchar(as.character(fermikit_flt[,5]))-nchar(as.character(fermikit_flt[,4]))>=1,]
    fermikit_flt_del <- fermikit_flt[nchar(as.character(fermikit_flt[,4]))-nchar(as.character(fermikit_flt[,5]))>=1,]
    # make all indels together
    for (j in 1:dim(fermikit_flt_ins)[1])
    {
      item <- vector()
      input_len <- nchar(as.character(fermikit_flt_ins[j,5]))-nchar(as.character(fermikit_flt_ins[j,4])) # insertion length is column 5 
      item_geno <- strsplit(as.character(fermikit_flt_ins[j,10]),":")[[1]][1]
      item <- c(chr,fermikit_flt_ins[j,2],input_len,item_geno)
      fermikit_sv_ins <- rbind(fermikit_sv_ins,item)  
    }
    for (j in 1:dim(fermikit_flt_del)[1])
    {
      item <- vector()
      input_len <- nchar(as.character(fermikit_flt_del[j,4]))-nchar(as.character(fermikit_flt_del[j,5])) # deletion length is column 4 
      item_geno <- strsplit(as.character(fermikit_flt_del[j,10]),":")[[1]][1]
      item <- c(chr,fermikit_flt_del[j,2],input_len,item_geno)
      fermikit_sv_del <- rbind(fermikit_sv_del,item)  
    }
    
    # summary(fermikit_flt_del1[,2]) max_length:197
    # summary(fermikit_flt_ins1[,2]) max_length:200
    
    # make matrix into dataframe and sort it by position
    rownames(fermikit_sv_del) <- seq(length=nrow(fermikit_sv_del))
    fermikit_sv_del <- data.frame(fermikit_sv_del)
    fermikit_sv_del <- fermikit_sv_del[order(as.numeric(as.character(fermikit_sv_del$X2))),]
    rownames(fermikit_sv_del) <- seq(length=nrow(fermikit_sv_del))
    rownames(fermikit_sv_ins) <- seq(length=nrow(fermikit_sv_ins))
    fermikit_sv_ins <- data.frame(fermikit_sv_ins)
    fermikit_sv_ins <- fermikit_sv_ins[order(as.numeric(as.character(fermikit_sv_ins$X2))),]
    rownames(fermikit_sv_ins) <- seq(length=nrow(fermikit_sv_ins))
    fermikit_sv_del <- data.frame(fermikit_sv_del)
    fermikit_sv_ins <- data.frame(fermikit_sv_ins)
    
    fermikit_sv_del_all <- rbind(fermikit_sv_del_all,fermikit_sv_del)
    fermikit_sv_ins_all <- rbind(fermikit_sv_ins_all,fermikit_sv_ins)
  }
  
  print(table(fermikit_sv_del[,4]))
  print(table(fermikit_sv_ins[,4]))
  
  write.table(fermikit_sv_del_all,paste0(location_path,"deletion_result.txt"),row.names = F,col.names = F,quote = F)
  write.table(fermikit_sv_ins_all,paste0(location_path,"insertion_result.txt"),row.names = F,col.names = F,quote = F)
}

path_prefix <- "/data/epouta1/B18010_indel_tool_evaluation/Semi-simulated_chr2/Other_tools/downstream_analysis/3_Results_evaluation/"
result_path <- c("100bp_30X_500/FermiKit/","100bp_60X_500/FermiKit/",
                 "250bp_30X_500/FermiKit/","250bp_30X_800/FermiKit/")
for (location in result_path)
{
  print(location)
  path_parse <- paste0(path_prefix,location)
  generate_tool_results(path_parse)
}





