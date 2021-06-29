truthset <- read.table("variants_truthset.txt")
deletion_truth <- truthset[truthset[,1]=="deletion" & truthset[,3]==10,] 
write.table(deletion_truth,"truth_variant_D10.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
deletion_op <- substr(deletion_truth[,6],4,nchar(as.character(deletion_truth[,6])))
deletion_truth <- cbind(deletion_truth,as.numeric(deletion_op))  
distance <- deletion_truth[,7]-deletion_truth[,2]
deletion_truth <- cbind(deletion_truth,distance) 
summary(distance)
hist(distance,breaks = 1000)  
plot(density(distance))  


set.seed(1233)
random <- sort(sample(1:249250621, 266, replace=FALSE))
# proof no overlap deletion regions for 10bp
for (i in 1:265)
{
  A <- random[i]
  B <- random[i+1]
  D <- B-A
  if (D <=10)
  {
    print (A)
  }
}
random2 <- random+10
name <- rep("deletion",266) 
D_random <- as.data.frame(cbind(name,random))
D_random <- cbind(D_random,random2)
write.table(D_random,"random_variant_D10.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
# 20 gaps above
gaps <- read.table("random_variant_D10_2.txt")
gaps_R <- gaps[gaps[,4]=="NNNNNNNNNN",2]
random3 <- random[!random %in% gaps_R]
set.seed(1234)
random4 <- sort(sample(1:249250621, 20, replace=FALSE))
random5 <- sort(c(random3,random4))
for (i in 1:265)
{
  A <- random5[i]
  B <- random5[i+1]
  D <- B-A
  if (D <=10)
  {
    print (A)
  }
}
random6 <- random5+10
name <- rep("deletion",266) 
D_random6 <- as.data.frame(cbind(name,random5))
D_random6 <- cbind(D_random6,random6)
write.table(D_random6,"random_variant_D10_3.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")

# 2 gaps above
gaps <- read.table("random_variant_D10_4.txt")
gaps_R <- gaps[gaps[,4]=="NNNNNNNNNN",2]
random7 <- random5[!random5 %in% gaps_R]
set.seed(1236)
random8 <- sort(sample(1:249250621, 2, replace=FALSE))
random9 <- sort(c(random7,random8))
for (i in 1:265)
{
  A <- random9[i]
  B <- random9[i+1]
  D <- B-A
  if (D <=10)
  {
    print (A)
  }
}
random10 <- random9+10
name <- rep("deletion",266) 
D_random10 <- as.data.frame(cbind(name,random9))
D_random10 <- cbind(D_random10,random10)
write.table(D_random10,"random_variant_D10_5.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")










































