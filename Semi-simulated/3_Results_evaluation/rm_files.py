path_prefix="/home/kning/seagate/Indel_calling/Github/Semi-simulated/3_Results_evaluation/"
tool_sets = ["DeepVariant/","DELLY/","FermiKit/","GATK_HC/","Pindel/","Platypus/", "Strelka2/","VarScan/"]
data_sets = ["5X/","30X/","30X_250bp/","60X/"]

rm_file = open("remove.sh","a")
for data in data_sets:
	for tool in tool_sets:
		command="rm " + path_prefix + data + tool + "shift_right_distance.txt"+"\n"
		rm_file.write(command)
		command="rm " + path_prefix + data + tool + "shift_right_distance_2.txt "+"\n"
		rm_file.write(command)
		command="rm " + path_prefix + data + tool + "variants_FP.vcf "+ "\n"
		rm_file.write(command)
		command="rm " + path_prefix + data + tool + "variants_FP_1.vcf "+ "\n"
		rm_file.write(command)
		command="rm " + path_prefix + data + tool + "repeat_FP.vcf"+ "\n"
		rm_file.write(command)

rm_file.close()

























