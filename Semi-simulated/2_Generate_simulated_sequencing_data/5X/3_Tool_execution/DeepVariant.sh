#!/bin/bash
#SBATCH --error dv3-pv.sim-clean_clean_Simulated-5x.8t.20g1c.err
#SBATCH --output dv3-pv.sim-clean_clean_Simulated-5x.8t.20g1c.out
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 1
#SBATCH --job-name DVarSim_3_1_1
#SBATCH --mem 20G
#SBATCH -p short
#SBATCH --nodelist=fmsc-05

N_SHARDS="8"

BIN_DIR=/site/app7/deepvariant-0.7.0
BASE_DIR=/proj_sim/clean_clean_Simulated-5x
CALL_VARIANTS_OUTPUT="${BASE_DIR}/2-call_variants_output.sim.clean_clean_Simulated-5x.tfrecord@${N_SHARDS}.gz"
FINAL_OUTPUT_VCF="${BASE_DIR}/dv070-3-output.sim.clean_clean_Simulated-5x.8t.20g1c.vcf.gz"

REF="/Simulated/hg19.chr1/chr1.fa"

/site/app7/deepvariant-0.7.0/bin/dvwrap-0.7.0 ${BIN_DIR}/postprocess_variants.zip \
  --ref "${REF}" \
  --infile "${CALL_VARIANTS_OUTPUT}" \
  --outfile "${FINAL_OUTPUT_VCF}"
