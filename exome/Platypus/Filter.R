Platypus_input <- read.table("variants.vcf")
Platypus_input <- Platypus_input[nchar(as.character(Platypus_input[,5]))>=50 |nchar(as.character(Platypus_input[,4]))>=50,]
Platypus_ins <- Platypus_input[nchar(as.character(Platypus_input[,5]))-nchar(as.character(Platypus_input[,4]))>=1,]
Platypus_del <- Platypus_input[nchar(as.character(Platypus_input[,4]))-nchar(as.character(Platypus_input[,5]))>=1,]
