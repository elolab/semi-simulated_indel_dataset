library(ggplot2)
make_plot <- function(P_file,R_file,file_name)
{
  # Grouped plot
  print_plot <- function(data_plot,y_name,plot_name)
  {
    p <- ggplot(data_plot,aes(fill=as.character(range_name),
                              y=as.numeric(as.character(value)),x=Callers))+ 
      geom_bar(stat="identity",color="black", position=position_dodge()) + 
      coord_flip(ylim=c(0,1)) + 
      labs(y=y_name, x = "Caller")
    p <- p + scale_fill_manual(values=c("#a6cee3","#1f78b4","#b2df8a","#33a02c","#000000"),
                               labels=c("> 500 bp","200 - 500 bp","50 - 200 bp"," 20 - 50 bp","1 - 20 bp"))
    p <- p + theme(
      axis.text.x = element_text(color = "black",size=27),
      axis.text.y = element_text(color = "black",size=37),
      axis.title.x = element_text(size = 32),
      axis.title.y = element_blank(),
      legend.position = "none",
      #legend.position = "bottom",
      #legend.text = element_text(size=40),
      #legend.title = element_text(size=40),
      panel.background = element_blank(),
      axis.line.x = element_line(colour="black",size=1),
      axis.line.y = element_blank(),
      axis.ticks.x = element_line(colour="black",size=1.25),
      panel.grid.minor = element_line(colour="gray", size=0.5))
    p <- p + guides(fill=guide_legend(title="Deletions size",reverse = T))
    p <- p + scale_x_discrete(labels=c("VarScan"="VarScan", "Strelka2"="Strelka2","Platypus"="Platypus","Pindel"="Pindel",
                                       "GATK_HC"="GATK HC","FermiKit"="FermiKit","DELLY"="DELLY","DeepVariant"="DeepVariant"))
    tiff(filename =plot_name,width = 650,height = 750, pointsize = 17)
    #tiff(filename ="legend2.tiff",width = 1800,height = 800, pointsize = 17)
    print(p)
    dev.off()
  }
  
  interval_names <- c("> 500 bp","200 - 500 bp","50 - 200 bp"," 20 - 50 bp","1 - 20 bp")
  
  P_data0 <- read.table(P_file,header = FALSE)
  P_data0[is.na(P_data0)] <-  0
  P_data <- P_data0[c(2,3,4,5,6,7,8,9),]
  P_data <- P_data[order(P_data[,1],decreasing = T),]
  P_data <- rbind(P_data0[1,],P_data)
  rownames(P_data) <- NULL
  P_data_frame <- vector()
  for (i in 2:9)
  {
    for (j in 2:6)
    {
      item <- vector()
      item <- c(as.character(P_data[i,1]),as.numeric(as.character(P_data[i,8-j])),
                as.numeric(as.character(P_data[1,8-j])))
      P_data_frame <- rbind(P_data_frame,item)
    }
  }
  P_data_frame <- data.frame(P_data_frame)
  colnames(P_data_frame) <- c("Callers","value","range")
  interval_names <- rep(interval_names,8)
  P_data_frame <- cbind(P_data_frame,interval_names)
  range_name <- rep((1:5),8)
  P_data_frame[,3] <- range_name
  P_data_frame$Callers <- factor(P_data_frame$Callers, levels = c("VarScan","Strelka2","Platypus",
                                                            "Pindel","GATK_HC","FermiKit","DELLY","DeepVariant"))
  file_name_p1 <- paste0(file_name,"_precision.tiff")
  print_plot(P_data_frame,"Precision",file_name_p1)
  
  R_data0 <- read.table(R_file,header = FALSE)
  R_data0[is.na(R_data0)] <-  0
  R_data <- R_data0[c(2,3,4,5,6,7,8,9),]
  R_data <- R_data[order(R_data[,1],decreasing = T),]
  R_data <- rbind(R_data0[1,],R_data)
  rownames(R_data) <- NULL
  R_data_frame <- vector()
  for (i in 2:9)
  {
    for (j in 2:6)
    {
      item <- vector()
      item <- c(as.character(R_data[i,1]),as.numeric(as.character(R_data[i,8-j])),
                as.numeric(as.character(R_data[1,8-j])))
      R_data_frame <- rbind(R_data_frame,item)
    }
  }
  R_data_frame <- data.frame(R_data_frame)
  colnames(R_data_frame) <- c("Callers","value","range")
  R_data_frame <- cbind(R_data_frame,interval_names)
  range_name <- rep((1:5),8)
  R_data_frame[,3] <- range_name
  R_data_frame$Callers <- factor(R_data_frame$Callers, levels = c("VarScan","Strelka2","Platypus",
                                                            "Pindel","GATK_HC","FermiKit","DELLY","DeepVariant"))
  file_name_p2 <- paste0(file_name,"_recall.tiff")
  print_plot(R_data_frame,"Recall",file_name_p2)
  
  Precision_value <- as.numeric(as.character(P_data_frame[,2]))
  Recall_value <- as.numeric(as.character(R_data_frame[,2]))
  F_data_frame_value <- 2*(Precision_value*Recall_value)/(Precision_value+Recall_value)
  F_data_frame_value[is.na(F_data_frame_value)] <- 0 
  F_data_frame <- as.data.frame(cbind(as.character(P_data_frame[,1]),F_data_frame_value,
                        as.numeric(P_data_frame[,3]),as.character(P_data_frame[,4])))
  colnames(F_data_frame) <- c("Callers","value","range","interval_names")
  F_data_frame$Callers <- factor(F_data_frame$Callers, levels = c("VarScan","Strelka2","Platypus",
                                                              "Pindel","GATK_HC","FermiKit","DELLY","DeepVariant"))
  file_name_p3 <- paste0(file_name,"_F1score.tiff")
  print_plot(F_data_frame,"F1 score",file_name_p3)
}

file_path <- "F:/University of Turku/PhD_project/Indel_calling/Revision/5000_limitation/Upper_limite_5000/3_Results_evaluation/"
data_sets <- c("100bp_5X_500","100bp_30X_500","100bp_60X_500","250bp_30X_500","250bp_30X_800")
file_set_genotype <- c("/Deletion_Precision_Genotype.txt","/Deletion_Recall_Genotype.txt",
                       "/Insertion_Precision_Genotype.txt","/Insertion_Recall_Genotype.txt")
output_file_genotype <- c("/deletion_Genotypes","/insertion_Genotype")
file_set <- c("/Deletion_Precision.txt","/Deletion_Recall.txt",
              "/Insertion_Precision.txt","/Insertion_Recall.txt")
output_file <- c("/deletion","/insertion")

for (i in 1:length(data_sets))
{
  print(data_sets[i])
  read_file_genotype <- paste0(file_path,data_sets[i],file_set_genotype)
  output_category_genotype <- paste0(file_path,data_sets[i],output_file_genotype)
  make_plot(read_file_genotype[1],read_file_genotype[2],output_category_genotype[1])
  make_plot(read_file_genotype[3],read_file_genotype[4],output_category_genotype[2])
  
  read_file <- paste0(file_path,data_sets[i],file_set)
  output_category <- paste0(file_path,data_sets[i],output_file)
  make_plot(read_file[1],read_file[2],output_category[1])
  make_plot(read_file[3],read_file[4],output_category[2])
}
# 
# i=4
# P_file <- read_file[1]
# R_file <- read_file[2]
# file_name <- output_category[1]
# # A <- c('DeepVariant','DELLY','FermiKit','GATK',
# #   'Platypus','Platypus_A','Pindel','Strelka2','VarScan')
# # B <- sort(A,decreasing = T)
# labels=c("> 500 bp","200 - 500 bp","50 - 200 bp"," 20 - 50 bp","1 - 20 bp")























