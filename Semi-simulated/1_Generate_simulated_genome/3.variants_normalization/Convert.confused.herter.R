truthset_ground <- read.table("Venter.truthset.left.align.txt")
colnames(truthset_ground)<- c("Type","Left.position","Sequence","OP","Genotype")
#new.position <- as.numeric(as.character(truthset_ground[,2]))#-as.numeric(as.character(truthset_ground[,3]))
#truthset_ground <- cbind(truthset_ground,new.position)
#truthset_ground[truthset_ground[,7]=="1/0",7] <- "0/1"
#truthset.deletion <- truthset_ground[truthset_ground[,5]=="deletion",]
#truthset.insertion <- truthset_ground[truthset_ground[,5]=="insertion",]

d <- truthset_ground[duplicated(truthset_ground[,2]),]
remove <- rownames(d)
truthset <- truthset_ground[!rownames(truthset_ground) %in% remove,]
rownames(truthset) <- seq(length=nrow(truthset))
# length <- nchar(as.character(d[,3]))
# duplication <- cbind(d,length)
# 
# # safety enough to delete all of them
# summary(length)
# table(duplication[,5])

length <- nchar(as.character(truthset[,3]))
truthset <- cbind(truthset,length)
weird <- vector()
for (i in 1:(dim(truthset)[1]-1))
{
  print (i)
  check = as.numeric(as.character(truthset[i,2]))+as.numeric(as.character(truthset[i,6]))
  if (check >= as.numeric(as.character(truthset[i+1,2])))
  {
    weird <- rbind(weird,truthset[i,2])
  }
}
truthset <- truthset[!(truthset[,2] %in% weird),]
truthset_for_analysis <- truthset[,-6]
#write.table(truthset_for_analysis,"Venter_truthset_for_analysis.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")







































truthset.haplotype1 <- truthset[truthset[,5]=="1/1"|truthset[,5]=="0/1",]
haplotype1 <- cbind(as.character(truthset.haplotype1[,5]),as.character(truthset.haplotype1[,2]),
                    as.character(truthset.haplotype1[,6]))
haplotype1 <- data.frame(haplotype1)
#write.table(haplotype1,"Haplotype_1.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
haplotype1_insertion <- truthset.haplotype1[truthset.haplotype1[,5]=="insertion",]
#write.table(haplotype1_insertion,"Haplotype_1_insertion.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")




truthset.haplotype2 <- truthset[truthset[,7]=="1/1"|truthset[,7]=="1/0",]
haplotype2 <- cbind(as.character(truthset.haplotype2[,5]),as.character(truthset.haplotype2[,2]),
                    as.character(truthset.haplotype2[,8]))
haplotype2 <- data.frame(haplotype2)
#write.table(haplotype2,"Haplotype_2.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
haplotype2_insertion <- truthset.haplotype2[truthset.haplotype2[,5]=="insertion",]
#write.table(haplotype2_insertion,"Haplotype_2_insertion.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")


a <- as.character(truthset[,5])
a2 <- truthset[,2]
a3 <- truthset[,8]
a4 <- as.character(truthset[,3])
a5 <- as.character(truthset[,7])
truthset_for_analysis <- cbind(a,a2,a3,a4,a5)
truthset_for_analysis <- data.frame(truthset_for_analysis)
#write.table(truthset_for_analysis,"Venter_truthset_for_analysis.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")











