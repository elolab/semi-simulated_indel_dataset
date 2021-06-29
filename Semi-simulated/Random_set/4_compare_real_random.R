truth <- read.table("truth_variant_D10_2.txt")
distance <- truth[,6]-truth[,2]
summary(distance)
hist(distance,breaks=88)
boxplot(distance)

random <- read.table("random_variant_D10_7.txt")
distance2 <- random[,6]-random[,2]
summary(distance2)
hist(distance2,breaks=20)
boxplot(distance2)
barplot(distance2)

library(ggplot2)
df <- as.data.frame(cbind(rep("Real deletions",266),distance))

df2 <- as.data.frame(cbind(rep("Random deletions",266),distance2))
colnames(df2) <- c("V1","distance")

df3 <- rbind(df,df2)
colnames(df3) <- c("Type","Ambiguous_regions")
df3[,2] <- as.numeric(as.character(df3[,2]))
library(plyr)
mu <- ddply(df3, "Type", summarise, grp.mean=mean(Ambiguous_regions))
head(mu)

compare <- ggplot(df3, aes(x=Ambiguous_regions,fill=Type,color=Type)) + 
  theme(legend.position="top") + 
  #geom_vline(data=mu, aes(xintercept=grp.mean, color=type),
  #           linetype="dashed")+
  geom_histogram(position="dodge",binwidth=2)
compare <- compare + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                           panel.background = element_blank(), axis.line = element_line(colour = "black"),
                           axis.title.x = element_text(size=14),axis.title.y = element_text(size=14),
                           legend.text=element_text(size=14),legend.title=element_text(size=14))
compare <- compare + xlab("Ambiguous regions(bp)") + ylab("Counts")
svg(filename ='difference.svg')
compare 
dev.off()





















