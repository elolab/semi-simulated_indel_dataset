library(ggplot2)

make_plot <- function(input_file,output_path)
{
  Results <- read.table(input_file,header = T)
  colnames(Results) <- c("Tool","TP","FP","FN","Precision","Recall","F1_Score")
  Results_D <-Results[c(1,4,7,10,13,16,19,22),]
  Results_I <-Results[c(2,5,8,11,14,17,20,23),]
  
  Results_frame_D <- vector()
  for (i in 1:8)
  {
    for (j in 5:7)
    {
      item <- vector()
      item <- c(as.character(Results_D[i,1]),as.numeric(as.character(Results_D[i,j])),
                as.character(colnames(Results_D)[j]))
      Results_frame_D <- rbind(Results_frame_D,item)
    }
  }
  Results_frame_D <- data.frame(Results_frame_D)
  colnames(Results_frame_D) <- c("Callers","value","category")
  Results_frame_D$category <- factor(Results_frame_D$category, levels = c("Precision","Recall","F1_Score"))
  
  
  library(ggplot2)
  # Plot
  p <- ggplot(Results_frame_D,aes(fill=as.character(category),
                                  y=as.numeric(as.character(value)),x=Callers))+ 
    geom_bar(stat="identity",color="black", position=position_dodge()) + coord_cartesian(ylim = c(0,1))
  p <- p + scale_fill_manual(values=c("#000000","#33a02c","#1f78b4"),
                             labels=c("F1 Score","Precision","Recall"))
  p <- p + theme(
    axis.text.x = element_text(color = "black",size=28,angle=45, hjust=1),
    axis.text.y = element_text(color = "black",size=28),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    legend.position = "none",
    #legend.position = "bottom",
    #legend.text = element_text(size=25),
    #legend.title = element_blank(),
    panel.background = element_blank(),
    axis.line.x = element_line(colour="black",size=1),
    axis.line.y = element_blank(),
    axis.ticks.x = element_line(colour="black",size=1.25),
    panel.grid.minor = element_line(colour="gray", size=0.5))
  p <- p + scale_x_discrete(labels=c("VarScan_D"="VarScan", "Strelka2_D"="Strelka2","Platypus_D"="Platypus","Pindel_D"="Pindel",
                                     "GATK_HC_D"="GATK HC","FermiKit_D"="FermiKit","DELLY_D"="DELLY","DeepVariant_D"="DeepVariant"))
  output_name <- paste0(output_path,"medium_deletion.tiff")
  tiff(filename =output_name,width = 900,height = 400, pointsize = 17)
  print(p)
  dev.off()   
  
  Results_frame_I <- vector()
  for (i in 1:8)
  {
    for (j in 5:7)
    {
      item <- vector()
      item <- c(as.character(Results_I[i,1]),as.numeric(as.character(Results_I[i,j])),
                as.character(colnames(Results_I)[j]))
      Results_frame_I <- rbind(Results_frame_I,item)
    }
  }
  Results_frame_I <- data.frame(Results_frame_I)
  colnames(Results_frame_I) <- c("Callers","value","category")
  Results_frame_I$category <- factor(Results_frame_I$category, levels = c("Precision","Recall","F1_Score"))
  
  
  library(ggplot2)
  # Plot
  p <- ggplot(Results_frame_I,aes(fill=as.character(category),
                                  y=as.numeric(as.character(value)),x=Callers))+ 
    geom_bar(stat="identity",color="black", position=position_dodge()) + coord_cartesian(ylim = c(0,1))
  p <- p + scale_fill_manual(values=c("#000000","#33a02c","#1f78b4"),
                             labels=c("F1 Score","Precision","Recall"))
  p <- p + theme(
    axis.text.x = element_text(color = "black",size=28,angle=45, hjust=1),
    axis.text.y = element_text(color = "black",size=28),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    legend.position = "none",
    #legend.position = "bottom",
    #legend.text = element_text(size=25),
    #legend.title = element_blank(),
    panel.background = element_blank(),
    axis.line.x = element_line(colour="black",size=1),
    axis.line.y = element_blank(),
    axis.ticks.x = element_line(colour="black",size=1.25),
    panel.grid.minor = element_line(colour="gray", size=0.5))
  p <- p + scale_x_discrete(labels=c("VarScan_I"="VarScan", "Strelka2_I"="Strelka2","Platypus_I"="Platypus","Pindel_I"="Pindel",
                                     "GATK_HC_I"="GATK HC","FermiKit_I"="FermiKit","DELLY_I"="DELLY","DeepVariant_I"="DeepVariant"))
  output_name <- paste0(output_path,"medium_insertion.tiff")
  tiff(filename =output_name,width = 900,height = 400, pointsize = 17)
  print(p)
  dev.off()   
  
}


file_path <- "F:/University of Turku/PhD_project/Indel_calling/Revision/5000_limitation/Upper_limite_5000/3_Results_evaluation/"
data_sets <- c("100bp_5X_500/","100bp_30X_500/","100bp_60X_500/","250bp_30X_500/","250bp_30X_800/")
file_name <- "Indel_35_65.txt"
for (i in 1:length(data_sets))
{
  print(data_sets[i])
  file_path2 <- paste0(file_path,data_sets[i])
  read_file <- paste0(file_path2,file_name)
  make_plot(read_file,file_path2)
}





































