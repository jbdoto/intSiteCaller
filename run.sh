#!/bin/bash -e

echo "Starting intSiteCaller..."
echo "cd /scratch/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}/${SAMPLE_ID} && conda run -n intSiteCaller Rscript /intSiteCaller/intSiteCaller.R"
cd "/scratch/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}/${SAMPLE_ID}" && conda run -n intSiteCaller Rscript /intSiteCaller/intSiteCaller.R
echo "intSiteCaller run complete...proceeding with post-run actions."
