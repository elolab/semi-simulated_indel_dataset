reference = open("chr1.fa","r")
referenceline = reference.readlines()
global b
seq=""
for j in referenceline[1:]: 
	a = j.replace("\n","") 
	seq=seq+a
b = seq

def cutting_right(start_C,pattern_C,length_C):
	variants_C = pattern_C.upper()
	suffix_coordinate = len(pattern_C)-1 
	print variants_C
	suffix = pattern_C[suffix_coordinate].upper()
	flank_left_coordinate = start_C-1	 
	flank_left = b[flank_left_coordinate].upper()	
	variants_pattern=variants_C

	while suffix == flank_left:
		variants_pattern = variants_pattern[len(variants_pattern)-1]+variants_pattern[:len(variants_pattern)-1]
		print variants_pattern
		if suffix_coordinate == 0:
			suffix_coordinate = len(pattern_C)
		suffix_coordinate = suffix_coordinate-1
		flank_left_coordinate = flank_left_coordinate-1
		suffix =variants_C[suffix_coordinate].upper()
		flank_left = b[flank_left_coordinate].upper()		
		
	flank_left_coordinate = flank_left_coordinate+1 
	return flank_left_coordinate, variants_pattern, length_C

bedA = open("Venter.truthset.txt","r")
fileA = open("Venter.truthset.left.align.txt","a")
bedlineA = bedA.readlines()
for i in range(0,43336):  
	item = bedlineA[i].split("\t")
	start = int(item[1]) # python & svsim zero-based, reference 1-based
	variants = item[3].replace("\n","")
	variants = variants.upper()
	length = len(variants)
	genotype = item[4].replace("\n","")

	left_cutting = cutting_right(start,variants,length)
	start = int(left_cutting[0])	
	variants = str(left_cutting[1])
	length = int(left_cutting[2])

	new_recordA = item[0]+"	"+str(start)+"	"+variants+"	"+"OP:"+str(int(item[1]))+"	"+genotype+"\n" 
	fileA.write(new_recordA)

bedA.close()
fileA.close()
reference.close()
