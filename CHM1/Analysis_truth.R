truth_D <- read.table("deletion_truthset.bed")
length <- as.numeric(as.character(truth_D[,3]))-as.numeric(as.character(truth_D[,2]))
truth_D <- cbind(truth_D,length)
truth_D <- truth_D[truth_D[,4]>=50,]
chromosome_list <- c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13",
                     "chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX")
truth_D <- truth_D[truth_D[,1] %in% chromosome_list,]
summary(truth_D[,4])
hist(truth_D[,4])
#write.table(truth_D,"deletion_truthset_normalChr.bed",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
truth_D_50 <- truth_D[truth_D[,4]>=50 & truth_D[,4]<500,]
truth_D_500 <- truth_D[truth_D[,4]>=500,]

truth_I <- read.table("insertion_truthset.bed")
length <- as.numeric(as.character(truth_I[,3]))-as.numeric(as.character(truth_I[,2]))
truth_I <- cbind(truth_I,length)
truth_I <- truth_I[truth_I[,4]>=50,]
chromosome_list <- c("chr1","chr2","chr3","chr4","chr5","chr6","chr7","chr8","chr9","chr10","chr11","chr12","chr13",
                     "chr14","chr15","chr16","chr17","chr18","chr19","chr20","chr21","chr22","chrX")
truth_I <- truth_I[truth_I[,1] %in% chromosome_list,]
summary(truth_I[,4])
hist(truth_I[,4])
#write.table(truth_I,"insertion_truthset_normalChr.bed",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
truth_I_50 <- truth_I[truth_I[,4]>=50 & truth_I[,4]<500,]
truth_I_500 <- truth_I[truth_I[,4]>=500, ]

