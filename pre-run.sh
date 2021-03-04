#!/bin/bash -e

# This pre-run.sh hook should only run once as part of the parent job.
# Child jobs will not download data.

prepare_workspace(){
  
  set -o noglob

  # should be in /scratch/results/$BATCH_JOB_ID/$BATCH_JOB_ATTEMPT/ directory at this point...see entrypoint.sh
  # sample data will end up in /scratch/results/$BATCH_JOB_ID/$BATCH_JOB_ATTEMPT/$SAMPLE_ID
  # For Lustre-based workloads, we don't need to download, files should be there.
  # OBJECT_NAME name parameter actually contains path info, like 'samples/G6RV5.tar.gz'
  # FILENAME just has G6RV5.tar.gz
  cp /scratch/results/${OBJECT_NAME} /scratch/results/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}/${FILENAME}

  # decompress tar.gz files:
  echo "I am in directory:"
  pwd

  if [[ ${FILENAME} == *.tar.gz ]]
  then
    cd /scratch/results/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}/
    echo "decompressing /scratch/results/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}/${FILENAME}..."
    tar -xzvf "/scratch/results/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}/${FILENAME}"
  else
    echo "tar.gz format not detected: ${FILENAME}."
  fi

}

# env will have following set:
# BUCKET_NAME: "intsitecaller-samples"
# OBJECT_NAME: "STEP-FUNCTION-WILL-PROVIDE" - full filename, eg: G6RV5.start.tar.gz
# SAMPLE_ID: "STEP-FUNCTION-WILL-PROVIDE" - sample identifier, eg G6RV5
# SERIAL_WAIT: "TRUE" - setting this to false runs everything in parallel, which will likely require a very large machine to run.

# Download inputs
prepare_workspace
