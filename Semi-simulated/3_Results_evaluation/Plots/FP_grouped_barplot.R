library(ggplot2)
make_plot <- function(data_frame,tool_name,output_name)
{
  p <- ggplot(data=data_frame, aes(x=Callers, y=Proportion,fill=Category)) + 
    geom_bar(stat="identity") + labs(y="Proportion", x = "Callers")
  p <- p + scale_fill_manual(values=c("#b2df8a","#1f78b4"),
                             labels=c("Non-SR region annotated indels", 
                                      "SR reagion annotated indels"))
  
  p <- p + theme(
    axis.text.x = element_text(color = "black",size=22.5,angle=45, hjust=1),
    axis.text.y = element_text(color = "black",size=22.5),
    axis.title.x = element_blank(),
    axis.title.y = element_text(size=28.5),
    legend.position = "none",
    #legend.position = "bottom",
    #legend.text = element_text(size=25),
    #legend.title = element_blank(),
    panel.background = element_blank(),
    axis.line.x = element_line(colour="black",size=1),
    axis.line.y = element_blank(),
    axis.ticks.x = element_line(colour="black",size=2),
    panel.grid.minor = element_line(colour="gray", size=0.5)) 
  p <- p + annotate("text", x = 1:8, y = 1.05, label = tool_name,size=7.25)
  #p <- p + guides(fill=guide_legend(title="False positives category"))
  figure_name <- paste0(output_name,"FP_category.tiff")
  tiff(filename=figure_name,width = 600,height = 412.5, pointsize = 17)
  #tiff(filename="FP_legend.tiff",width = 1200,height = 800, pointsize = 17)
  print(p)
  dev.off()
}

file_path <- "F:/University of Turku/PhD_project/Indel_calling/Revision/5000_limitation/Upper_limite_5000/3_Results_evaluation/"
data_sets <- c("100bp_5X_500/","100bp_30X_500/","100bp_60X_500/","250bp_30X_500/","250bp_30X_800/")
for (m in 1:length(data_sets))
{
  read_file_name <- paste0(file_path,data_sets[m],"FP_summary.txt")
  print(read_file_name)
  read_file <- read.table(read_file_name)
  read_file2 <- read_file[,c(2,3)]
  colnames(read_file2) <- c("Simple repeat reagions variant", "Non-simple repeat regions variant")
  rownames(read_file2) <- c("DeepVariant","DELLY","FermiKit","GATK HC","Pindel","Platypus","Strelka2","VarScan")
  file_matrix <- as.matrix(read_file2)
  file_matrix <- t(file_matrix)
  file_matrix2 <- prop.table(file_matrix,2)
  bar_table <- vector()
  for(i in 1:dim(file_matrix2)[1])
  {
    for (j in 1:dim(file_matrix2)[2])
    {
      item <- c(row.names(file_matrix2)[i],colnames(file_matrix2)[j],as.numeric(file_matrix2[i,j]))
      bar_table <- rbind(bar_table,item)
    }
  }
  
  bar_table <- data.frame(bar_table)
  bar_table[,3] <- as.numeric(as.character(bar_table[,3]))
  colnames(bar_table) <- c("Category","Callers","Proportion")
  bar_table$Category <- factor(bar_table$Category, levels = c("Non-simple repeat regions variant", 
                                                              "Simple repeat reagions variant"))
  total_FP <- read_file[,1]
  path_data <- paste0(file_path,data_sets[m])
  make_plot(bar_table,total_FP,path_data)
}

# m=4























