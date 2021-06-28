D <- read.table("Pindel_D.vcf")
D_50 <- D[nchar(as.character(D[,4]))>50 |nchar(as.character(D[,5])) >50,]
c <- row.names(D_50)
D <- D[!rownames(D) %in% c,]

I <- read.table("Pindel_SI.vcf")
I_50 <- I[nchar(as.character(I[,4]))>50 |nchar(as.character(I[,5])) >50,]
c <- row.names(I_50)
I <- I[!rownames(I) %in% c,]

TD <- read.table("Pindel_TD.vcf")
TD_50 <- TD[nchar(as.character(TD[,4]))>50 |nchar(as.character(TD[,5])) >50,]

results <- rbind(D,I)
results <- results[order(results$V1),]
rownames(results) <- seq(length=nrow(results))
write.table(results,"Pindel_short.vcf",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")






















