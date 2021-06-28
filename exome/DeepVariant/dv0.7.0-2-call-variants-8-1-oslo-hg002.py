import os

moduleCommand = "module add python/2.7.10"+"\n"
BIN_DIR = "/site/app7/deepvariant-0.7.0"
BASE_DIR = "/epouta/genomics/B18021_Variant_calling_method_evaluation/proj_oslo/aligned_to_hs37d5/HG002"
OUTPUT_DIR = BASE_DIR + "/dv0.7.0"
CALL_VARIANTS_OUTPUT = BASE_DIR + "/2-call_variants_output.tfrecord.gz"

MODEL_VERSION = "0.7.0"
MODEL_NAME = "DeepVariant-inception_v3-" + str(MODEL_VERSION) + "+data-wes_standard"
MODEL = MODEL_NAME + "/model.ckpt"

shards = 8
for i in range(shards):
	dvPythonCommand = '/site/app7/deepvariant-0.7.0/bin/dvwrap-0.7.0 ' + BIN_DIR + '/call_variants.zip  \
 --outfile ' + OUTPUT_DIR + '/2-call_variants_output.oslo.HG002.wes.tfrecord-0000' + str(i) + '-of-0000' + str(shards) + '.gz \
 --examples ' + OUTPUT_DIR + '/1-examples.oslo.HG002.wes.examples.tfrecord-0000' + str(i) + '-of-0000' + str(shards) + '.gz \
 --checkpoint ' + BIN_DIR + "/extras/" + MODEL + "\n"

	dvPythonCommand += "EOF"	
	SLURMheader = "sbatch <<EOF\n"
	SLURMheader += "#!/bin/bash\n"
	SLURMheader += "#SBATCH --ntasks 1"+"\n"
	SLURMheader += "#SBATCH --cpus-per-task 1"+"\n"
	SLURMheader += "#SBATCH --job-name DV07-Oslo-2_8_1"+"\n"
	SLURMheader += "#SBATCH --mem-per-cpu 3G"+"\n"
        SLURMheader += "#SBATCH -p normal"+"\n"
        #SLURMheader += "#SBATCH -t 10:00:00"+"\n"
	SLURMheader += "#SBATCH --nodelist=fmsc-05"+"\n"
	SLURMheader += "#SBATCH --error " + BASE_DIR + "/logs_dv/dv0.7.0-e-2-8-1-oslo-hg002-s"+str(i)+".err"+"\n"
	SLURMheader += "#SBATCH --output " + BASE_DIR + "/logs_dv/dv0.7.0-e-2-8-1-oslo-hg002-s"+str(i)+".out"+"\n"

	command = SLURMheader+moduleCommand+dvPythonCommand
	print command
	print
	os.system(command)
