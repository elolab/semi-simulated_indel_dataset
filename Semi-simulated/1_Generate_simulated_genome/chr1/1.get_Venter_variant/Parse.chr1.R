# # Homozygous indels

# Homo.insertion <- read.table("chr20.homozygous.insertion.gff")
# Homo.insertion.position <- as.character(Homo.insertion[,4])
# Homo.insertion.length <- nchar(as.character(Homo.insertion[,10]))
# Insertion.name <- rep("insertion",6008)
# Insertion.homo <- cbind(Insertion.name, Homo.insertion.position,Homo.insertion.length)
# #summary(Homo.insertion.length)
# Homo.deletion <- read.table("chr20.homozygous.deletion.gff")
# Homo.deletion.position <- as.character(Homo.deletion[,4])
# Homo.deletion.length <- nchar(as.character(Homo.deletion[,10]))
# Deletion.name <- rep("deletion",5622)
# Deletion.homo <- cbind(Deletion.name, Homo.deletion.position,Homo.deletion.length)
# #summary(Homo.deletion.length)

Homo.Indels <- read.table("chr1.homozygous.indels.gff")
Homo.Indels <- Homo.Indels[Homo.Indels[,1]=="1",]
Homo.Indels.types <- vector()
for (i in 1:dim(Homo.Indels)[1])
{
  print (i)
  if (Homo.Indels[i,11]=="Homozygous_Insertion")
  {
    Homo.Indels.types <- c(Homo.Indels.types,"insertion")
  }
  if (Homo.Indels[i,11]=="Homozygous_Deletion")
  {
    Homo.Indels.types <- c(Homo.Indels.types,"deletion")
  }
}
Homo.Indels.position <- as.character(Homo.Indels[,4])
Homo.Indels.length <- nchar(as.character(Homo.Indels[,10]))
summary(Homo.Indels.length)
Homo.Indels.sequences <- as.character(Homo.Indels[,10])
Indels.homo <- cbind(Homo.Indels.types, Homo.Indels.position,Homo.Indels.length,Homo.Indels.sequences)
Indels.homo <- data.frame(Indels.homo)
#----------------------------------------------------------------------------------------------------------------------#

#----------------------------------------------------------------------------------------------------------------------#
#In order to pick indels fpr heterzygous can cover all range, I need to split for different range sizes
SVs.1000 <- Indels.homo[as.numeric(as.character(Indels.homo[,3]))>1000,]# & as.numeric(as.character(Indels.homo[,3]))<1000,]
SVs.1000 <- data.frame(SVs.1000)
SVs.500 <- Indels.homo[as.numeric(as.character(Indels.homo[,3]))>500 & as.numeric(as.character(Indels.homo[,3]))<=1000,]
SVs.500 <- data.frame(SVs.500)
SVs.200 <- Indels.homo[as.numeric(as.character(Indels.homo[,3]))>200 & as.numeric(as.character(Indels.homo[,3]))<=500,]
SVs.200 <- data.frame(SVs.200)
SVs.100 <- Indels.homo[as.numeric(as.character(Indels.homo[,3]))>100 & as.numeric(as.character(Indels.homo[,3]))<=200,]
SVs.100 <- data.frame(SVs.100)
SVs.50 <- Indels.homo[as.numeric(as.character(Indels.homo[,3]))>50 & as.numeric(as.character(Indels.homo[,3]))<=100,]
SVs.50 <- data.frame(SVs.50)
SVs.1 <- Indels.homo[as.numeric(as.character(Indels.homo[,3]))>0 & as.numeric(as.character(Indels.homo[,3]))<=50,]
SVs.1 <- data.frame(SVs.1)
# check if there are overlap  ---- no overlap
# for (i in 1:(dim(Indels.homo)[1]-1))
# {
#   if (Indels.homo[i,1]=="deletion")
#   {
#     pos <- as.numeric(as.character(Indels.homo[i,2]))+as.numeric(as.character(Indels.homo[i,3]))
#     if (pos >= as.numeric(as.character(Indels.homo[i+1,2])))
#     {
#       print (as.numeric(as.character(Indels.homo[i,2])))
#     }
#   }
# }
#--------------------------------------------------------------------------------------------------------------------#

#--------------------------------------------------------------------------------------------------------------------#
# pick some of to make homozygous as heterzygous sets, plan to pick only SV, due to short indels has enough heterzygous
# pick the first haplotype SV
SV.Indels.homo_1.1000 <- SVs.1000[sample(nrow(SVs.1000),10),]
summary(as.numeric(as.character(SV.Indels.homo_1.1000[,3])))
# remove the picked one from 1000 SV set
SVs.1000 <- SVs.1000[!(SVs.1000$Homo.Indels.position %in% SV.Indels.homo_1.1000$Homo.Indels.position),]
# remove the picked one from Homo SV set
Indels.homo <- Indels.homo[!(Indels.homo$Homo.Indels.position %in% SV.Indels.homo_1.1000$Homo.Indels.position),]

SV.Indels.homo_1.500 <- SVs.500[sample(nrow(SVs.500),10),]
summary(as.numeric(as.character(SV.Indels.homo_1.500[,3])))
SVs.500 <- SVs.500[!(SVs.500$Homo.Indels.position %in% SV.Indels.homo_1.500$Homo.Indels.position),]
Indels.homo <- Indels.homo[!(Indels.homo$Homo.Indels.position %in% SV.Indels.homo_1.500$Homo.Indels.position),]

SV.Indels.homo_1.200 <- SVs.200[sample(nrow(SVs.200),40),]
summary(as.numeric(as.character(SV.Indels.homo_1.200[,3])))
SVs.200 <- SVs.200[!(SVs.200$Homo.Indels.position %in% SV.Indels.homo_1.200$Homo.Indels.position),]
Indels.homo <- Indels.homo[!(Indels.homo$Homo.Indels.position %in% SV.Indels.homo_1.200$Homo.Indels.position),]

SV.Indels.homo_1.100 <- SVs.100[sample(nrow(SVs.100),30),]
summary(as.numeric(as.character(SV.Indels.homo_1.100[,3])))
SVs.100 <- SVs.100[!(SVs.100$Homo.Indels.position %in% SV.Indels.homo_1.100$Homo.Indels.position),]
Indels.homo <- Indels.homo[!(Indels.homo$Homo.Indels.position %in% SV.Indels.homo_1.100$Homo.Indels.position),]

SV.Indels.homo_1.50 <- SVs.50[sample(nrow(SVs.50),50),]
summary(as.numeric(as.character(SV.Indels.homo_1.50[,3])))
SVs.50 <- SVs.50[!(SVs.50$Homo.Indels.position %in% SV.Indels.homo_1.50$Homo.Indels.position),]
Indels.homo <- Indels.homo[!(Indels.homo$Homo.Indels.position %in% SV.Indels.homo_1.50$Homo.Indels.position),]

SV.Indels.homo_1.1 <- SVs.1[sample(nrow(SVs.1),6000),]
summary(as.numeric(as.character(SV.Indels.homo_1.1[,3])))
SVs.1 <- SVs.1[!(SVs.1$Homo.Indels.position %in% SV.Indels.homo_1.1$Homo.Indels.position),]
Indels.homo <- Indels.homo[!(Indels.homo$Homo.Indels.position %in% SV.Indels.homo_1.1$Homo.Indels.position),]

# pick the second haplotype SV
SV.Indels.homo_2.1000 <- SVs.1000[sample(nrow(SVs.1000),10),]
summary(as.numeric(as.character(SV.Indels.homo_2.1000[,3])))
# remove the picked one from 1000 SV set
SVs.1000 <- SVs.1000[!(SVs.1000$Homo.Indels.position %in% SV.Indels.homo_2.1000$Homo.Indels.position),]
# remove the picked one from Homo SV set
Indels.homo <- Indels.homo[!(Indels.homo$Homo.Indels.position %in% SV.Indels.homo_2.1000$Homo.Indels.position),]

SV.Indels.homo_2.500 <- SVs.500[sample(nrow(SVs.500),10),]
summary(as.numeric(as.character(SV.Indels.homo_2.500[,3])))
SVs.500 <- SVs.500[!(SVs.500$Homo.Indels.position %in% SV.Indels.homo_2.500$Homo.Indels.position),]
Indels.homo <- Indels.homo[!(Indels.homo$Homo.Indels.position %in% SV.Indels.homo_2.500$Homo.Indels.position),]

SV.Indels.homo_2.200 <- SVs.200[sample(nrow(SVs.200),40),]
summary(as.numeric(as.character(SV.Indels.homo_2.200[,3])))
SVs.200 <- SVs.200[!(SVs.200$Homo.Indels.position %in% SV.Indels.homo_2.200$Homo.Indels.position),]
Indels.homo <- Indels.homo[!(Indels.homo$Homo.Indels.position %in% SV.Indels.homo_2.200$Homo.Indels.position),]

SV.Indels.homo_2.100 <- SVs.100[sample(nrow(SVs.100),30),]
summary(as.numeric(as.character(SV.Indels.homo_2.100[,3])))
SVs.100 <- SVs.100[!(SVs.100$Homo.Indels.position %in% SV.Indels.homo_2.100$Homo.Indels.position),]
Indels.homo <- Indels.homo[!(Indels.homo$Homo.Indels.position %in% SV.Indels.homo_2.100$Homo.Indels.position),]

SV.Indels.homo_2.50 <- SVs.50[sample(nrow(SVs.50),50),]
summary(as.numeric(as.character(SV.Indels.homo_2.50[,3])))
SVs.50 <- SVs.50[!(SVs.50$Homo.Indels.position %in% SV.Indels.homo_2.50$Homo.Indels.position),]
Indels.homo <- Indels.homo[!(Indels.homo$Homo.Indels.position %in% SV.Indels.homo_2.50$Homo.Indels.position),]

SV.Indels.homo_2.1 <- SVs.1[sample(nrow(SVs.1),6000),]
summary(as.numeric(as.character(SV.Indels.homo_2.1[,3])))
SVs.1 <- SVs.1[!(SVs.1$Homo.Indels.position %in% SV.Indels.homo_2.1$Homo.Indels.position),]
Indels.homo <- Indels.homo[!(Indels.homo$Homo.Indels.position %in% SV.Indels.homo_2.1$Homo.Indels.position),]
#------------------------------------------------------------------------------------------------------------------#

#------------------------------------------------------------------------------------------------------------------#
# formation of two version of reference genome
# mark the heter with 1/0 and homo with 1/1
Indels.homo <- cbind(Indels.homo,rep("1/1",31057))
colnames(Indels.homo) <- c("Type", "Position", "Size","Sequence","genotype")

SV.Indels.homo_1.1000 <- cbind(SV.Indels.homo_1.1000,rep("1/0",10))
colnames(SV.Indels.homo_1.1000) <- c("Type", "Position", "Size","Sequence","genotype")
SV.Indels.homo_1.500 <- cbind(SV.Indels.homo_1.500,rep("1/0",10))
colnames(SV.Indels.homo_1.500) <- c("Type", "Position", "Size","Sequence","genotype")
SV.Indels.homo_1.200 <- cbind(SV.Indels.homo_1.200,rep("1/0",40))
colnames(SV.Indels.homo_1.200) <- c("Type", "Position", "Size","Sequence","genotype")
SV.Indels.homo_1.100 <- cbind(SV.Indels.homo_1.100,rep("1/0",30))
colnames(SV.Indels.homo_1.100) <- c("Type", "Position", "Size","Sequence","genotype")
SV.Indels.homo_1.50 <- cbind(SV.Indels.homo_1.50,rep("1/0",50))
colnames(SV.Indels.homo_1.50) <- c("Type", "Position", "Size","Sequence","genotype")
SV.Indels.homo_1.1 <- cbind(SV.Indels.homo_1.1,rep("1/0",6000))
colnames(SV.Indels.homo_1.1) <- c("Type", "Position", "Size","Sequence","genotype")

SV.Indels.homo_2.1000 <- cbind(SV.Indels.homo_2.1000,rep("0/1",10))
colnames(SV.Indels.homo_2.1000) <- c("Type", "Position", "Size","Sequence","genotype")
SV.Indels.homo_2.500 <- cbind(SV.Indels.homo_2.500,rep("0/1",10))
colnames(SV.Indels.homo_2.500) <- c("Type", "Position", "Size","Sequence","genotype")
SV.Indels.homo_2.200 <- cbind(SV.Indels.homo_2.200,rep("0/1",40))
colnames(SV.Indels.homo_2.200) <- c("Type", "Position", "Size","Sequence","genotype")
SV.Indels.homo_2.100 <- cbind(SV.Indels.homo_2.100,rep("0/1",30))
colnames(SV.Indels.homo_2.100) <- c("Type", "Position", "Size","Sequence","genotype")
SV.Indels.homo_2.50 <- cbind(SV.Indels.homo_2.50,rep("0/1",50))
colnames(SV.Indels.homo_2.50) <- c("Type", "Position", "Size","Sequence","genotype")
SV.Indels.homo_2.1 <- cbind(SV.Indels.homo_2.1,rep("0/1",6000))
colnames(SV.Indels.homo_2.1) <- c("Type", "Position", "Size","Sequence","genotype")
#------------------------------------------------------------------------------------------------------------------#

#------------------------------------------------------------------------------------------------------------------#
# kick out the in-consistant variants
Indel_all <- rbind(Indels.homo,SV.Indels.homo_1.1000,SV.Indels.homo_1.500,SV.Indels.homo_1.200,SV.Indels.homo_1.100,
                   SV.Indels.homo_1.50,SV.Indels.homo_1.1,SV.Indels.homo_2.1000,SV.Indels.homo_2.500,SV.Indels.homo_2.200,
                   SV.Indels.homo_2.100,SV.Indels.homo_2.50,SV.Indels.homo_2.1)
Indel_all <- Indel_all[order(as.numeric(as.character(Indel_all[,2]))),]
rownames(Indel_all) <- seq(length=nrow(Indel_all))
# check whether there are overlap variants
# duplicated(Indel_1[,2]) original simulated set has many overlap variants, many deletion and insertion at same position
Indel_all.no_duplicates <- Indel_all[!duplicated(Indel_all[,2]),]

# remove the overlapped deletion 
Indel_all_ready <- Indel_all.no_duplicates
wrong.pos <- vector()
for (i in 1:43336) # length of indel_all_no_duplicates -1, due the the last position need to be manul check
{
  if (Indel_all.no_duplicates[i,1]=="deletion")
  {
    pos <- as.numeric(as.character(Indel_all.no_duplicates[i,2]))+as.numeric(as.character(Indel_all.no_duplicates[i,3]))
    if (pos >= as.numeric(as.character(Indel_all.no_duplicates[i+1,2])))
    {
      wrong.pos <- c(wrong.pos,as.numeric(as.character(Indel_all.no_duplicates[i,2])))
      #print (Indel_1[i,])
      #print (as.numeric(as.character(Indel_1[i,2])),as.numeric(as.character(Indel_1[i,3])))
    }
  }
}
Indel_all_ready <- Indel_all_ready[!(Indel_all_ready[,2] %in% wrong.pos),]
#------------------------------------------------------------------------------------------------------------------#

#------------------------------------------------------------------------------------------------------------------#
# generate two haplotypes
Indel_1 <- Indel_all_ready[Indel_all_ready[,5]=="1/1" | Indel_all_ready[,5]=="1/0",]
Indel_2 <- Indel_all_ready[Indel_all_ready[,5]=="1/1" | Indel_all_ready[,5]=="0/1",]
#------------------------------------------------------------------------------------------------------------------#

#------------------------------------------------------------------------------------------------------------------#
# make the files for simulated reads
write.table(Indel_1,"Chr1.haplotype_1.variants_1.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")
write.table(Indel_2,"Chr1.haplotype_2.variants_1.txt",row.names = FALSE,col.names = FALSE,quote = FALSE, sep = "\t")






























