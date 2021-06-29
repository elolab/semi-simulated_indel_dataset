reference = open("/home/kning/Bio/Indels_calling/mfranberg_simulated/Venter/chr1/svsim_haplotypes/Repeat/left-align/left.align.truthset/Prove.which.is.correct.truth.set/chr1.fa","r")
referenceline = reference.readlines()
global b
seq=""
for j in referenceline[1:]: # get rid of ">chr1"
	a = j.replace("\n","") # put all the lines into one sequence
	seq=seq+a
b = seq
#123456 due to random position land into gaps, so kick off gaps position, re-random some position, until no gaps anymore
bedA = open("random_variant_D10_5.txt","r")
fileA = open("random_variant_D10_6.txt","a")
bedlineA = bedA.readlines()
for i in range(0,266):  
	item = bedlineA[i].split("\t")
	start = int(item[1]) # python & svsim zero-based, reference 1-based
	end = int(item[2])
	variants = b[start:end]
	variants = variants.upper()
	length = 10
	genotype = "1/1"
	OP = item[1]

	new_recordA = item[0]+"	"+item[1]+"	"+str(length)+"	"+variants+"	"+"OP:"+OP+"	"+genotype+"\n" 
	fileA.write(new_recordA)

bedA.close()
fileA.close()
reference.close()










































