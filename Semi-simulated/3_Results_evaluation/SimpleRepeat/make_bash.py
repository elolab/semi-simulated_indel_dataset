file_write=open("annotation_simpleRepeat.sh","a")
path_prefix="/3_Results_evaluation/"
tool_sets = ["DeepVariant/","DELLY/","FermiKit/","GATK_HC/","Pindel/","Platypus/","Strelka2/","VarScan/"]
data_sets = ["100bp_5X_500/","100bp_30X_500/","100bp_60X_500/","250bp_30X_500/","250bp_30X_800/"]

# bedtools/2.29.2 module avail
file_write.write("#!/bin/sh"+"\n")
file_write.write("#SBATCH --cpus-per-task 1"+"\n")
file_write.write("#SBATCH --error bedtools.Error.txt"+"\n")
file_write.write("#SBATCH --output bedtools.Output.txt"+"\n")
file_write.write("#SBATCH --partition short"+"\n")
file_write.write("#SBATCH --job-name bedtools"+"\n")
file_write.write(""+"\n")
file_write.write("module add bedtools"+"\n")

for data in data_sets:
	for tool in tool_sets:
		command="bedtools intersect -a "+path_prefix+data+tool+"variants_FP.vcf -b hg19_chr1_chr2_SimpleRepeat.bed -wa > "+path_prefix+data+tool+"repeat_FP.bed"+"\n"
		file_write.write(command)
		file_write.write(""+"\n")

file_write.close()
