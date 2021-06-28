Results <- read.table("input.txt",header = T)

Results_frame <- vector()
for (i in 1:7)
{
  for (j in 2:4)
  {
    item <- vector()
    item <- c(as.character(Results[i,1]),as.numeric(as.character(Results[i,j])),
              as.character(colnames(Results)[j]))
    Results_frame <- rbind(Results_frame,item)
  }
}
Results_frame <- data.frame(Results_frame)
colnames(Results_frame) <- c("Callers","value","category")
Results_frame$category <- factor(Results_frame$category, levels = c("Precision","Recall","F1_Score"))


library(ggplot2)
# Plot
p <- ggplot(Results_frame,aes(fill=as.character(category),
                           y=as.numeric(as.character(value)),x=Callers))+ 
  geom_bar(stat="identity",color="black", position=position_dodge()) + coord_cartesian(ylim = c(0.5,1))
p <- p + scale_fill_manual(values=c("#000000","#33a02c","#1f78b4"),
                           labels=c("F1 Score","Precision","Recall"))
p <- p + theme(
  axis.text.x = element_text(color = "black",size=20,angle=45, hjust=1),
  axis.text.y = element_text(color = "black",size=20),
  axis.title.x = element_blank(),
  axis.title.y = element_blank(),
  #legend.position = "none",
  legend.position = "bottom",
  legend.text = element_text(size=25),
  legend.title = element_blank(),
  panel.background = element_blank(),
  axis.line.x = element_line(colour="black",size=1),
  axis.line.y = element_blank(),
  axis.ticks.x = element_line(colour="black",size=1.25),
  panel.grid.minor = element_line(colour="gray", size=0.5))
p <- p + scale_x_discrete(labels=c("VarScan"="VarScan", "Strelka2"="Strelka2","Platypus"="Platypus","Pindel"="Pindel",
                                   "GATK_HC"="GATK HC","FermiKit"="FermiKit","DeepVariant"="DeepVariant"))
tiff(filename ="exom2.tiff",width = 900,height = 400, pointsize = 17)
print(p)
dev.off()   











































