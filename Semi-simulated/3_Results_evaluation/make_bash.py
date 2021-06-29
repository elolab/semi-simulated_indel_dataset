file_write=open("annotation_simpleRepeat.sh","a")
path_prefix="/home/kning/seagate/Indel_calling/Github/Semi-simulated/3_Results_evaluation/"
tool_sets = ["DeepVariant/","DELLY/","FermiKit/","GATK_HC/","Pindel/","Platypus/","Strelka2/","VarScan/"]
data_sets = ["5X/","30X/","30X_250bp/","60X/"]

for data in data_sets:
	for tool in tool_sets:
		command="bedtools intersect -a "+path_prefix+data+tool+"variants_FP.vcf -b hg19_chr1_simpleRepeat.bed -wa > "+path_prefix+data+tool+"repeat_FP.vcf"+"\n"
		file_write.write(command)

file_write.close()
