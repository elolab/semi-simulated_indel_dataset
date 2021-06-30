library(ggplot2)
make_plot <- function(file_name,file_name2)
{
  input_file <- read.table(file_name,header=T)
  Data_input <- vector()
  for (i in 1:dim(input_file)[1])
  {
    item <- vector()
    item <- c(item,as.character(input_file[i,1]))
    for (j in 2:dim(input_file)[2])
    {
      A <- as.numeric(strsplit(as.character(input_file[i,j]),"/")[[1]][1])
      B <- as.numeric(strsplit(as.character(input_file[i,j]),"/")[[1]][2])
      value <- A/B
      item <- c(item,value)
    }
    Data_input <- rbind(Data_input,item)
  }
  
  input_file2 <- read.table(file_name2,header=T)
  item_label <- vector()
  for (i in 1:dim(input_file2)[1])
  {
    for (j in 2:dim(input_file2)[2])
    {
      item_label <- c(item_label,as.character(input_file2[i,j]))
    }
  }
  
  Results_frame <- vector()
  for (i in 1:dim(Data_input)[1])
  {
    for (j in 2:dim(Data_input)[2])
    {
      item <- vector()
      item <- c(as.character(Data_input[i,1]),as.numeric(as.character(Data_input[i,j])),
                as.character(colnames(input_file)[j]))
      Results_frame <- rbind(Results_frame,item)
    }
  }
  Results_frame <- data.frame(Results_frame)
  colnames(Results_frame) <- c("Callers","value","category")
  Results_frame$category <- factor(Results_frame$category, levels = c("Precision","Recall"))
  

  # Plot
  p <- ggplot(Results_frame,aes(fill=as.character(category),
                                y=as.numeric(as.character(value)),x=Callers))+ 
    geom_bar(stat="identity",color="black", position=position_dodge()) + coord_cartesian(ylim = c(0,1.05))
  p <- p + scale_fill_manual(values=c("#33a02c","#1f78b4"),
                             labels=c("Precision","Recall"))
  p <- p + theme(
    axis.text.x = element_text(color = "black",size=30),
    axis.text.y = element_text(color = "black",size=25),
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
  p <- p + scale_x_discrete(labels=c("Platypus_A"="Platypus","Pindel"="Pindel",
                                     "FermiKit"="FermiKit","Delly"="DELLY"))
  p <- p + annotate("text", x = c(0.78,1.24,1.78,2.24,2.78,3.24,3.78,4.24), 
                    y = as.numeric(as.character(Results_frame$value))+0.04, 
                    label = item_label,size=7)
  output_name <- paste0(file_name,".tiff")
  tiff(filename =output_name,width = 900,height = 400, pointsize = 17)
  #tiff(filename ="legend.tiff",width = 900,height = 400, pointsize = 17)
  print(p)
  dev.off()   
}

input_list <- c("D_50.txt","D_500.txt","I_50.txt","I_500.txt")
input_list2 <- c("D_50_2.txt","D_500_2.txt","I_50_2.txt","I_500_2.txt")
for (i in 1:length(input_list))
{
  make_plot(input_list[i],input_list2[i])
}

































































