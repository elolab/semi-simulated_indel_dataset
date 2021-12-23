truth_D <- read.table("F:/University of Turku/PhD_project/Indel_calling/Github/CHM1/deletion_truthset_normalChr.bed")
truth_D <- truth_D[truth_D[,4]>=50 & truth_D[,4]<10000,]
summary(truth_D[,4])
hist(truth_D[,4])
truth_D_50 <- truth_D[truth_D[,4]>=50 & truth_D[,4]<200,]
truth_D_200 <- truth_D[truth_D[,4]>=200 & truth_D[,4]<5000,]
truth_D_500 <- truth_D[truth_D[,4]>=500 & truth_D[,4]<10000,]

truth_I <- read.table("F:/University of Turku/PhD_project/Indel_calling/Github/CHM1/insertion_truthset_normalChr.bed")
truth_I <- truth_I[truth_I[,4]>=50 & truth_I[,4]<10000,]
summary(truth_I[,4])
hist(truth_I[,4])
truth_I_50 <- truth_I[truth_I[,4]>=50 & truth_I[,4]<200,]
truth_I_200 <- truth_I[truth_I[,4]>=200 & truth_I[,4]<500,]
truth_I_500 <- truth_I[truth_I[,4]>=500 & truth_I[,4]<10000,]

