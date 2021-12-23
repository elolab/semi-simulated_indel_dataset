library(ggplot2)
make_plot <- function(input_file,output_name)
{
  for (m in 1:length(input_file))
  {
    file_geno <- read.table(input_file[m])
    name_reserve <- c("homo_precision","heter_precision")
    tool_name <- as.character(file_geno[,1])[2:dim(file_geno)[1]]
    file_geno <- file_geno[2:dim(file_geno)[1],2:dim(file_geno)[2]]
    row.names(file_geno) <- tool_name
    colnames(file_geno) <- name_reserve
    
    data_frame <- vector()
    for (i in 1:dim(file_geno)[1])
    {
      for (j in 1:(dim(file_geno)[2]))
      {
        item <- vector()
        item <- c(as.character(row.names(file_geno)[i]),as.numeric(as.character(file_geno[i,3-j])),
                  as.character(colnames(file_geno)[3-j]))
        data_frame <- rbind(data_frame,item)
      }
    }
    data_frame <- data.frame(data_frame)
    colnames(data_frame) <- c("Callers","value","category")
    data_name <- rep(c(1:(dim(file_geno)[2])),8)
    data_frame[,3] <- data_name
    data_frame$Callers <- factor(data_frame$Callers, levels = c("VarScan","Strelka2","Platypus",
                                                                "Pindel","GATK_HC","FermiKit","DELLY","DeepVariant"))
    
    # Plot
    p <- ggplot(data_frame,aes(fill=as.character(category),
                               y=as.numeric(as.character(value)),x=Callers))+ 
      geom_bar(stat="identity",color="black", position=position_dodge()) + 
      coord_flip(ylim=c(0,1)) + 
      labs(y="Genotype percentage", x = "Caller",size=150)
    p <- p + scale_fill_manual(values=c("#33a02c","#1f78b4"),
                               labels=c("Heterozygous precision","Homozygous precision"))
    p <- p + theme(
      axis.text.x = element_text(color = "black",size=25),
      axis.text.y = element_text(color = "black",size=28),
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      legend.position = "none",
      #legend.position = "bottom",
      #legend.text = element_text(size=30),
      #legend.title = element_blank(),
      panel.background = element_blank(),
      axis.line.x = element_line(colour="black",size=1),
      axis.line.y = element_blank(),
      axis.ticks.x = element_line(colour="black",size=1.25),
      panel.grid.minor = element_line(colour="gray", size=0.5))
    p <- p + scale_x_discrete(labels=c("VarScan"="VarScan", "Strelka2"="Strelka2","Platypus"="Platypus","Pindel"="Pindel",
                                       "GATK_HC"="GATK HC","FermiKit"="FermiKit","DELLY"="DELLY","DeepVariant"="DeepVariant"))
    p <- p + guides(fill=guide_legend(title="Genotypes category",reverse = T))
    tiff(filename =output_name[m],width = 550,height = 700, pointsize = 17)
    #tiff(filename ="legend_geno.tiff",width = 1800,height = 800, pointsize = 17)
    print(p)
    dev.off()                                                            
  }
}
file_path <- "F:/University of Turku/PhD_project/Indel_calling/Revision/5000_limitation/Upper_limite_5000/3_Results_evaluation/"
data_sets <- c("100bp_5X_500/","100bp_30X_500/","100bp_60X_500/","250bp_30X_500/","250bp_30X_800/")

read_file <- paste0(file_path,data_sets,"/Genotype_accuracy.txt")
output_file <- paste0(file_path,data_sets,"/genotype.tiff")
make_plot(read_file,output_file)

read_file <- paste0(file_path,data_sets,"/Genotype_accuracy_small.txt")
output_file <- paste0(file_path,data_sets,"/genotype_small.tiff")
make_plot(read_file,output_file)

read_file <- paste0(file_path,data_sets,"/Genotype_accuracy_large.txt")
output_file <- paste0(file_path,data_sets,"/genotype_large.tiff")
make_plot(read_file,output_file)

# input_file <- paste0(file_path,data_sets,"/Genotype_accuracy.txt")
# output_name <- output_file
# 
# 
# 
# m=1
input_file[m] <- "G:/Indel_calling/Revision/downstream_analysis/3_Results_evaluation/100bp_5X_500/Genotype_accuracy.txt"



















































