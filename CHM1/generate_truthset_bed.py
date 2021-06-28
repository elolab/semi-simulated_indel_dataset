files = open("deletion.bed","r")
filelines = files.readlines()
truthset = open("deletion_truthset.bed","a")
for i in filelines:
	item = i.split("\t")
	chromosome = item[0]
	Start = item[1]
	End = item[2]
	record = str(chromosome)+"	"+str(Start)+"	"+str(End)#+"\n"
	truthset.write(record)

files.close()
truthset.close()

files2 = open("insertion.bed","r")
filelines2 = files2.readlines()
truthset2 = open("insertion_truthset.bed","a")
for i in filelines2:
	item = i.split("\t")
	chromosome = item[0]
	Start = item[1]
	End = item[2]
	record = str(chromosome)+"	"+str(Start)+"	"+str(End)#+"\n"
	truthset2.write(record)

files2.close()
truthset2.close()
