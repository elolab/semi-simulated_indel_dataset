#!/bin/bash
#SBATCH --error /epouta/genomics/B18021_Variant_calling_method_evaluation/proj_oslo/aligned_to_hs37d5/HG002/logs_dv/dv0.7.0-e-3-20g1c-oslo-hg002.err
#SBATCH --output /epouta/genomics/B18021_Variant_calling_method_evaluation/proj_oslo/aligned_to_hs37d5/HG002/logs_dv/dv0.7.0-e-3-20g1c-oslo-hg002.out
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 1
#SBATCH --job-name DVarOslo_3_1_1
#SBATCH --mem 20G
#SBATCH -p short
#SBATCH --nodelist=fmsc-05

module add python/2.7.10

N_SHARDS="8"

BIN_DIR=/site/app7/deepvariant-0.7.0
BASE_DIR=/epouta/genomics/B18021_Variant_calling_method_evaluation/proj_oslo/aligned_to_hs37d5/HG002/dv0.7.0
CALL_VARIANTS_OUTPUT="${BASE_DIR}/2-call_variants_output.oslo.HG002.wes.tfrecord@${N_SHARDS}.gz"
FINAL_OUTPUT_VCF="${BASE_DIR}/dv0.7.0-output.oslo.HG002.wes.8t.20g1c.vcf.gz"

INPUT_DIR="/epouta/group/elo/B18021_Variant_calling_method_evaluation/data/dve/"
REF="${INPUT_DIR}/hs37d5.fa.gz"

/site/app7/deepvariant-0.7.0/bin/dvwrap-0.7.0 ${BIN_DIR}/postprocess_variants.zip \
  --ref "${REF}" \
  --infile "${CALL_VARIANTS_OUTPUT}" \
  --outfile "${FINAL_OUTPUT_VCF}"
