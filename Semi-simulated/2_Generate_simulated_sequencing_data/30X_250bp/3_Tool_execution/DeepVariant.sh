#!/bin/bash
#SBATCH --error /wrk/sofia/local/B18021_Variant_calling_method_evaluation/proj_sim_latest/logs_dv/dv.0.7.0-sin-250bp.err
#SBATCH --output /wrk/sofia/local/B18021_Variant_calling_method_evaluation/proj_sim_latest/logs_dv/dv.0.7.0-sin-250bp.out
#SBATCH --cpus-per-task 24
#SBATCH --mem 32GB
#SBATCH -C stable
#SBATCH --job-name DVSin0.7.0

BASE="/wrk/sofia/local/B18021_Variant_calling_method_evaluation/proj_sim_latest"

BIN_VERSION="0.7.0"

MODEL_VERSION="0.7.0"
MODEL_NAME="DeepVariant-inception_v3-${MODEL_VERSION}+data-wgs_standard"
MODELS_DIR="${BASE}/models"
MODEL="${MODELS_DIR}/model.ckpt"

N_SHARDS=24

INPUT_DIR="${BASE}/data"
OUTPUT_DIR="${BASE}/250bp"
LOG_DIR="${BASE}/logs_dv"

REF="${INPUT_DIR}/chr1.fa"
BAM="${INPUT_DIR}/RG.2x250.BWA-M.SORTED.SAM.bam"

#REF="chr1.fa"
#BAM="RG.2x250.BWA-M.SORTED.SAM.bam"

EXAMPLES="${OUTPUT_DIR}/RG.2x250.BWA-M.SORTED.dv-0.7.0.examples.tfrecord@${N_SHARDS}.gz"
GVCF_TFRECORDS="${OUTPUT_DIR}/RG.2x250.BWA-M.SORTED.dv-0.7.0.gvcf.tfrecord@${N_SHARDS}.gz"
CALL_VARIANTS_OUTPUT="${OUTPUT_DIR}/RG.2x250.BWA-M.SORTED.dv-0.7.0.cvo.tfrecord.gz"

OUTPUT_VCF="${OUTPUT_DIR}/RG.2x250.BWA-M.SORTED.dv-0.7.0.output.vcf.gz"
OUTPUT_GVCF="${OUTPUT_DIR}/RG.2x250.BWA-M.SORTED.dv-0.7.0.output.g.vcf.gz"

#OUTPUT_VCF="RG.2x250.BWA-M.SORTED.output.vcf.gz"
#OUTPUT_GVCF="RG.2x250.BWA-M.SORTED.output.g.vcf.gz"
 

echo "Running make_examples ..."
( time seq 0 $((N_SHARDS-1)) | \
singularity exec /appl/sofia/deepvariant-sin/deepvariant.0.7.0.sif \
  parallel -k --line-buffer \
      /opt/deepvariant/bin/make_examples \
      --mode calling \
      --ref "${REF}" \
      --reads "${BAM}" \
      --examples "${EXAMPLES}" \
      --gvcf "${GVCF_TFRECORDS}" \
      --task {} \
) 2>&1 | tee "${LOG_DIR}/dv.0.7.0-1-make_examples.log"
echo "Done."
echo


## Run `call_variants`
echo "Running call_variants ..."
( time singularity exec /appl/sofia/deepvariant-sin/deepvariant.0.7.0.sif \
    /opt/deepvariant/bin/call_variants \
    --outfile "${CALL_VARIANTS_OUTPUT}" \
    --examples "${EXAMPLES}" \
    --checkpoint "${MODEL}"
) 2>&1 | tee "${LOG_DIR}/dv0.7.0-2-call_variants.log"
echo "Done."
echo


## Run `postprocess_variants`, with gVCFs.
echo "Running postprocess_variants (with gVCFs) ..."
( time singularity exec /appl/sofia/deepvariant-sin/deepvariant.0.7.0.sif \
    /opt/deepvariant/bin/postprocess_variants \
    --ref "${REF}" \
    --infile "${CALL_VARIANTS_OUTPUT}" \
    --outfile "${OUTPUT_VCF}" \
    --nonvariant_site_tfrecord_path "${GVCF_TFRECORDS}" \
    --gvcf_outfile "${OUTPUT_GVCF}"
) 2>&1 | tee "${LOG_DIR}/dv.0.7.0-3-postprocess_variants.withGVCF.log"
echo "Done."
echo

