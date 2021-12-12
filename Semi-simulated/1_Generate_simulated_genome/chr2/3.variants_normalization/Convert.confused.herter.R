truthset_ground <- read.table("Venter.truthset.left.align.chr2.txt")
colnames(truthset_ground)<- c("Type","Left.position","Sequence","OP","Genotype")

d <- truthset_ground[duplicated(truthset_ground[,2]),]
remove <- rownames(d)
truthset <- truthset_ground[!rownames(truthset_ground) %in% remove,]
rownames(truthset) <- seq(length=nrow(truthset))


length <- nchar(as.character(truthset[,3]))
truthset <- cbind(truthset,length)
wried_truthset <- vector()
for (i in 1:(dim(truthset)[1]-1))
{
  print(i)
  position_1 <- as.numeric(substr(as.character(truthset[i,4]),4,nchar(as.character(truthset[i,4]))))
  position_2 <- as.numeric(substr(as.character(truthset[i,4]),4,nchar(as.character(truthset[i,4]))))+as.numeric(truthset[i,6])
  position_3 <- as.numeric(as.character(truthset[i+1,2]))
  if ((position_3-position_2)<=1 & truthset[i,1]=="deletion")
  {
    wried_truthset <- rbind(wried_truthset,truthset[i,])
    wried_truthset <- rbind(wried_truthset,truthset[i+1,])
  }
  else if ((position_3-position_1)<=1 & truthset[i,1]=="insertion")
  {
    wried_truthset <- rbind(wried_truthset,truthset[i,])
    wried_truthset <- rbind(wried_truthset,truthset[i+1,])
  }
}
wried_truthset <- wried_truthset[!duplicated(wried_truthset), ]
truthset <- truthset[!(truthset[,2] %in% wried_truthset[,2]),]
truthset_for_analysis <- truthset[,-6]
write.table(truthset_for_analysis,"Venter_truthset_for_analysis.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
