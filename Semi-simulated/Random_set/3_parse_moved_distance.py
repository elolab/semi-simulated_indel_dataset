reference = open("/home/kning/Bio/Indels_calling/mfranberg_simulated/Venter/chr1/svsim_haplotypes/Repeat/left-align/left.align.truthset/Prove.which.is.correct.truth.set/chr1.fa","r")
referenceline = reference.readlines()
global b
seq=""
for j in referenceline[1:]: # get rid of ">chr1"
	a = j.replace("\n","") # put all the lines into one sequence
	seq=seq+a
b = seq

def cutting_right(start_C,pattern_C,length_C):
	print "C"
	variants_C = pattern_C.upper()
	suffix_coordinate = len(pattern_C)-1 # last letter of variants
	print variants_C
	suffix = pattern_C[suffix_coordinate].upper()
	flank_left_coordinate = start_C-1	 
	flank_left = b[flank_left_coordinate].upper()	
	variants_pattern=variants_C

	while suffix == flank_left:
		variants_pattern = variants_pattern[len(variants_pattern)-1]+variants_pattern[:len(variants_pattern)-1]
		print variants_pattern
		#print variants_pattern
		if suffix_coordinate == 0:
			suffix_coordinate = len(pattern_C)
		suffix_coordinate = suffix_coordinate-1
		flank_left_coordinate = flank_left_coordinate-1
		print flank_left_coordinate
		suffix =variants_C[suffix_coordinate].upper()
		print suffix
		flank_left = b[flank_left_coordinate].upper()
		print flank_left		
		
	flank_left_coordinate = flank_left_coordinate+1 # new start, python 0-base +1 and deleted trings must include the base before the event -1 are neutralized
	print flank_left_coordinate,variants_pattern

	return flank_left_coordinate, variants_pattern, length_C

def cutting_left(start_C,pattern_C,length_C):
	print "C"
	variants_C = pattern_C.upper()
	prefix_coordinate = 0 # last letter of variants
	print variants_C
	prefix = pattern_C[prefix_coordinate].upper()
	flank_right_coordinate = start_C	 
	flank_right = b[flank_right_coordinate].upper()
	print flank_right
	variants_pattern=variants_C

	while prefix == flank_right:
		variants_pattern = variants_pattern[1:len(variants_pattern)]+variants_pattern[0]
		print variants_pattern
		prefix_coordinate = prefix_coordinate+1
		flank_right_coordinate = flank_right_coordinate+1
		if prefix_coordinate == length_C:
			prefix_coordinate = 0
		prefix =variants_C[prefix_coordinate].upper()
		flank_right = b[flank_right_coordinate].upper()
		print flank_right
	start_new = flank_right_coordinate # new start, python 0-base +1 and deleted trings must include the base before the event -1 are neutralized
	print start_new,variants_pattern

	return start_new, variants_pattern, length_C

bedA = open("truth_variant_D10.txt","r")
fileA = open("truth_variant_D10_2.txt","a")
bedlineA = bedA.readlines()
for i in range(0,266):  
	item = bedlineA[i].split("\t")
	start = int(item[1]) # python & svsim zero-based, reference 1-based
	variants = item[3]
	variants = variants.upper()
	length = len(variants)
	genotype = item[4].replace("\n","")
	OP = item[5].replace("\n","")

	right_cutting = cutting_left(start,variants,length)
	end = int(right_cutting[0])-10
	left_cutting = cutting_right(start,variants,length)
	start = int(left_cutting[0])	
	variants = str(left_cutting[1])
	length = int(left_cutting[2])

	new_recordA = item[0]+"	"+str(start)+"	"+str(length)+"	"+variants+"	"+OP+"	"+str(end)+"	"+genotype+"\n" 
	fileA.write(new_recordA)

bedA.close()
fileA.close()
reference.close()










































