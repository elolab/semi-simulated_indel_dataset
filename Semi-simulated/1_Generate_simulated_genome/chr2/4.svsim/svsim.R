variants <- read.table("Venter_truthset_for_analysis.txt")

haplotype_1 <- variants[variants[,5]=="1/1" | variants[,5]=="1/0",]
haplotype_2 <- variants[variants[,5]=="1/1" | variants[,5]=="0/1",]

length_hap1 <- nchar(as.character(haplotype_1[,3]))
svsim_1 <- cbind(as.character(haplotype_1[,1]),as.character(haplotype_1[,2]),length_hap1)
svsim_1 <- as.data.frame(svsim_1)
write.table(svsim_1,"Haplotype_1.chr2.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
svsim1_ins <- haplotype_1[haplotype_1[,1]=="insertion",]
write.table(svsim1_ins,"Haplotype_1_insertion.chr2.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")

length_hap2 <- nchar(as.character(haplotype_2[,3]))
svsim_2 <- cbind(as.character(haplotype_2[,1]),as.character(haplotype_2[,2]),length_hap2)
svsim_2 <- as.data.frame(svsim_2)
write.table(svsim_2,"Haplotype_2.chr2.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
svsim2_ins <- haplotype_2[haplotype_2[,1]=="insertion",]
write.table(svsim2_ins,"Haplotype_2_insertion.chr2.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")

length_V <- nchar(as.character(variants[,3]))
variants_table <- cbind(as.character(variants[,1]),
                        as.character(variants[,2]),
                        length_V,
                        as.character(variants[,3]),
                        as.character(variants[,5]),
                        as.character(variants[,4]))
write.table(variants_table,"variants_truthset.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")


































