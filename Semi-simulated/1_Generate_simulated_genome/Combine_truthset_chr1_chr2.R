chr1 <- read.table("chr1_variants_truthset.txt")
tag <- rep("chr1",dim(chr1)[1])
chr1 <- cbind(chr1,tag)

chr2 <- read.table("chr2_variants_truthset.txt")
tag <- rep("chr2",dim(chr2)[1])
chr2 <- cbind(chr2,tag)

truthset <- rbind(chr1,chr2)

write.table(truthset,"chr1_chr2_variants_truthset.txt",row.names = F,col.names = F,quote = F)
