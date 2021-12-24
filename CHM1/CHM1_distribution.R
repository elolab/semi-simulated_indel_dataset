del <- read.table("deletion_truthset_normalChr.bed",header = F,sep = "\t")
del <- del[del[,4]>=50 & del[,4]<10000,]
ins <- read.table("insertion_truthset_normalChr.bed",header = F,sep = "\t")
ins <- ins[ins[,4]>=50 & ins[,4]<10000,]
CHM1_len <- c(del[,4],ins[,4])
CHM1_type <- c(rep("Deletion",dim(del)[1]),rep("Insertion",dim(ins)[1]))
CHM1_indel <- cbind(CHM1_type,as.numeric(as.character(CHM1_len)))
CHM1_indel <- as.data.frame(CHM1_indel)
colnames(CHM1_indel) <- c("Type","length")
CHM1_indel$length=as.numeric(levels(CHM1_indel$length))[CHM1_indel$length]
summary(CHM1_len)

library(ggplot2)
p <- ggplot(CHM1_indel,aes(x=length,fill=Type)) +
  geom_histogram(binwidth = 200) +xlim(c(50, 10000)) +
  scale_fill_manual(values=c("#1f78b4", "#33a02c")) +
  labs(y="Counts", x = "Indel length (bp)") +
  theme(axis.title = element_text(size=20),
        axis.text = element_text(size=18),
        legend.title = element_text(size = 20), 
        legend.text = element_text(size = 18))

tiff(filename ="CHM1_indel_distribution.tiff",width = 900,height = 400, pointsize = 17)
print(p)
dev.off() 




















































































