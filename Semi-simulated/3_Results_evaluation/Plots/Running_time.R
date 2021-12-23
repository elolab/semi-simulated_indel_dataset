library(ggplot2)

read_file_name <- "F:/University of Turku/PhD_project/Indel_calling/Revision/downstream_analysis/3_Results_evaluation/100bp_30X_500/Runtime.txt"
read_file <- read.table(read_file_name,sep = "\t")
row.names(read_file) <- read_file[,1]
read_file <- read_file[,-1]
colnames(read_file) <- c("Tool total CPU time","Pre-processes total CPU time",
                         "Tool process maximum memory","Pre-processes maximum memory")
y_name_list <- c("CPU utilized (min)","Memory utilized (GB)")
output <- c("CPU2.tiff","Memory2.tiff")
col_pick <- c(1,2)
file_matrix <- as.matrix(read_file[,c(col_pick)])
file_matrix <- t(file_matrix)
bar_table <- vector()
for(i in 1:dim(file_matrix)[1])
{
  for (j in 1:dim(file_matrix)[2])
  {
    item <- c(row.names(file_matrix)[i],colnames(file_matrix)[j],as.numeric(file_matrix[i,j]))
    bar_table <- rbind(bar_table,item)
  }
}
bar_table <- data.frame(bar_table)
bar_table[,3] <- as.numeric(as.character(bar_table[,3]))
colnames(bar_table) <- c("Category","Callers","Value")
bar_table$Category <- factor(bar_table$Category, levels = colnames(read_file)[c(1,2)])
output_path <- paste0("F:/University of Turku/PhD_project/Indel_calling/Revision/downstream_analysis/3_Results_evaluation/evaluation_code/Plots/",output[1])
data_frame <- bar_table
y_name <- y_name_list[1]
levels_name <- colnames(read_file)[c(1,2)]
output_name <- output_path

p <- ggplot(data=data_frame, aes(x=Callers, y=Value,fill=Category)) + 
  geom_bar(stat="identity",position="stack") + labs(y=y_name, x = "Callers")
p <- p + scale_fill_manual(values=c("#b2df8a","#1f78b4"),
                           labels=levels_name)
p <- p + theme(
  axis.text.x = element_text(color = "black",size=23,angle=45, hjust=1),
  axis.text.y = element_text(color = "black",size=23),
  axis.title.x = element_blank(),
  axis.title.y = element_text(size=26),
  legend.position = "none",
  #legend.position = "right",
  #legend.text = element_text(size=20),
  #legend.title = element_blank(),
  panel.background = element_blank(),
  axis.line.x = element_line(colour="black",size=1),
  axis.line.y = element_blank(),
  axis.ticks.x = element_line(colour="black",size=1.25),
  panel.grid.minor = element_line(colour="gray", size=0.5)) 
p <- p + scale_x_discrete(labels=c("VarScan"="VarScan", "Strelka2"="Strelka2","Platypus"="Platypus","Pindel"="Pindel",
                                   "GATK_HC"="GATK HC","FermiKit"="FermiKit","DELLY"="DELLY","DeepVariant"="DeepVariant"))
tiff(filename=output_name,width = 700,height = 500)
print(p)
dev.off()

read_file_name <- "F:/University of Turku/PhD_project/Indel_calling/Revision/downstream_analysis/3_Results_evaluation/100bp_30X_500/Runtime.txt"
read_file <- read.table(read_file_name,sep = "\t")
row.names(read_file) <- read_file[,1]
read_file <- read_file[,-1]
colnames(read_file) <- c("Tool total CPU time","Pre-processes total CPU time",
                         "Tool process maximum memory","Pre-processes maximum memory")
y_name_list <- c("CPU utilized (min)","Memory utilized (GB)")
output <- c("CPU2.tiff","Memory2.tiff")
col_pick <- c(3,4)
file_matrix <- as.matrix(read_file[,c(col_pick)])
file_matrix <- t(file_matrix)
bar_table <- vector()
for(i in 1:dim(file_matrix)[1])
{
  for (j in 1:dim(file_matrix)[2])
  {
    item <- c(row.names(file_matrix)[i],colnames(file_matrix)[j],as.numeric(file_matrix[i,j]))
    bar_table <- rbind(bar_table,item)
  }
}
bar_table <- data.frame(bar_table)
bar_table[,3] <- as.numeric(as.character(bar_table[,3]))
colnames(bar_table) <- c("Category","Callers","Value")
bar_table$Category <- factor(bar_table$Category, levels = colnames(read_file)[c(4,3)])
output_path <- paste0("F:/University of Turku/PhD_project/Indel_calling/Revision/downstream_analysis/3_Results_evaluation/evaluation_code/Plots/",output[2])
data_frame <- bar_table
y_name <- y_name_list[2]
levels_name <- colnames(read_file)[c(4,3)]
output_name <- output_path

p <- ggplot(data=data_frame, aes(x=Callers, y=Value,fill=Category)) + 
  geom_bar(stat="identity",position=position_dodge()) + labs(y=y_name, x = "Callers")
p <- p + scale_fill_manual(values=c("#1f78b4","#b2df8a"),
                           labels=levels_name)
p <- p + theme(
  axis.text.x = element_text(color = "black",size=23,angle=45, hjust=1),
  axis.text.y = element_text(color = "black",size=23),
  axis.title.x = element_blank(),
  axis.title.y = element_text(size=26),
  legend.position = "none",
  #legend.position = "right",
  #legend.text = element_text(size=20),
  #legend.title = element_blank(),
  panel.background = element_blank(),
  axis.line.x = element_line(colour="black",size=1),
  axis.line.y = element_blank(),
  axis.ticks.x = element_line(colour="black",size=1.25),
  panel.grid.minor = element_line(colour="gray", size=0.5))
p <- p + scale_x_discrete(labels=c("VarScan"="VarScan", "Strelka2"="Strelka2","Platypus"="Platypus","Pindel"="Pindel",
                                   "GATK_HC"="GATK HC","FermiKit"="FermiKit","DELLY"="DELLY","DeepVariant"="DeepVariant"))
tiff(filename=output_name,width = 700,height = 500)
print(p)
dev.off()


























































































