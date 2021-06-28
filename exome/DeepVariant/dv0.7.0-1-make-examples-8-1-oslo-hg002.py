import os

moduleCommand = "module add python/2.7.10"+"\n"
shards = 8

BIN_DIR = "/site/app7/deepvariant-0.7.0/"
#INPUT_DIR = "/epouta/group/elo/B18021_Variant_calling_method_evaluation/data/dve/"
INPUT_DIR = "/epouta/group/elo/B18021_Variant_calling_method_evaluation/data/quartet-oslo/"

BASE_DIR = "/epouta/group/elo/B18021_Variant_calling_method_evaluation/proj_oslo/aligned_to_hs37d5/HG002"
OUTPUT_DIR = BASE_DIR + "/dv0.7.0/"
GVCF_TFRECORDS = OUTPUT_DIR + '/1-examples.oslo.HG002.wes.gvcf.tfrecord@' + str(shards) + '.gz'
EXAMPLES = OUTPUT_DIR + '/1-examples.oslo.HG002.wes.examples.tfrecord@' + str(shards) + '.gz'

TRIO_DIR = INPUT_DIR + 'aj-trio/'

#CAPTURE_BED = INPUT_DIR + "agilent_sureselect_human_all_exon_v5_b37_targets.bed"
#CAPTURE_BED = TRIO_DIR + "vcf-regions/" + "wex_Agilent_SureSelect_v05_b37.baits.slop50.merged.list"
CAPTURE_BED = TRIO_DIR + "vcf-regions/" + "wex_Agilent_SureSelect_v05_b37.baits.slop50.merged.bed"

REF = INPUT_DIR + "/hs37d5.fa.gz"

#BAM = INPUT_DIR + "/151002_7001448_0359_AC7F6GANXX_Sample_HG002-EEogPU_v02-KIT-Av5_AGATGTAC_L008.posiSrt.markDup.bam"
BAM = TRIO_DIR + 'NA24385_son_HG002/bam/151002_7001448_0359_AC7F6GANXX_Sample_HG002-EEogPU_v02-KIT-Av5_AGATGTAC_L008.posiSrt.markDup.bam'

for i in range(shards):
	#dvPythonCommand = '/site/app7/deepvariant-0.6.0/bin/deepvariant-wrapped-python ' + BIN_DIR + '/make_examples.zip --mode calling --ref ' + BIN_DIR + '/extras/quickstart-testdata/ucsc.hg19.chr20.unittest.fasta --reads ' + BIN_DIR + '/extras/quickstart-testdata/NA12878_S1.chr20.10_10p1mb.bam --regions "chr20:10,000,000-10,010,000" --examples "/epouta/group/elo/B18021_Variant_calling_method_evaluation/deeptest-e-case-study/8t/1-examples.tfrecord@' + str(shards) + '.gz" --task ' + str(i) + "\n"

	dvPythonCommand = '/site/app7/deepvariant-0.7.0/bin/dvwrap-0.7.0 ' + BIN_DIR + '/make_examples.zip \
	 --mode calling \
	 --ref ' + REF + ' \
	 --reads ' + BAM + ' \
	 --gvcf ' + GVCF_TFRECORDS + ' \
	 --examples ' + EXAMPLES + ' \
	 --regions ' + CAPTURE_BED + ' \
	 --task ' + str(i) + "\n"

	dvPythonCommand += "EOF"
	
	SLURMheader = "sbatch <<EOF\n"
	SLURMheader += "#!/bin/bash\n"
	SLURMheader += "#SBATCH --ntasks 1"+"\n"
	SLURMheader += "#SBATCH --cpus-per-task 1"+"\n"
	SLURMheader += "#SBATCH --job-name DV07-Oslo-1_8_1"+"\n"
        SLURMheader += "#SBATCH -p normal"+"\n"
        #SLURMheader += "#SBATCH -t 12:00:00"+"\n"
	SLURMheader += "#SBATCH --mem-per-cpu 4G"+"\n"
	SLURMheader += "#SBATCH --nodelist=fmsc-05"+"\n"
	SLURMheader += "#SBATCH --error " + BASE_DIR + "/logs_dv/dv0.7.0-e-1-8-1-oslo-hg002-s"+str(i)+".err"+"\n"
	SLURMheader += "#SBATCH --output " + BASE_DIR + "/logs_dv/dv0.7.0-e-1-8-1-oslo-hg002-s"+str(i)+".out"+"\n"

	command = SLURMheader+moduleCommand+dvPythonCommand
	print command
	print
	os.system(command)

