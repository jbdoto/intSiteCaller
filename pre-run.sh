#!/bin/bash -e

download(){
  
  set -o noglob

  local from=$1
  local files=$2

  # should be in /scratch/$BATCH_JOB_ID/$BATCH_JOB_ATTEMPT/ directory at this point...see entrypoint.sh
  # sample data will end up in /scratch/$BATCH_JOB_ID/$BATCH_JOB_ATTEMPT/$SAMPLE_ID
  for file in ${files}
  do
    echo "aws s3 cp ${from} . --recursive --exclude \"*\" --include \"${file}\""
    aws s3 cp ${from} . --recursive --exclude "*" --include "${file}"

    # decompress tar.gz files:
    if [[ $file == *.tar.gz ]]
    then
      echo "decompressing ${file}..."
      tar -xzvf "${file}"
    fi

  done
}

# Job results path in job results bucket
if [[ $STATE_MACHINE_NAME ]]; then
  jobresults=${JOBRESULTS_BUCKET}/${SAMPLE_ID}/${STATE_MACHINE_NAME}/${EXECUTION_NAME}
else
  jobresults=${JOBRESULTS_BUCKET}/${1}
fi


# env will have following set:
# BUCKET_NAME: "intsitecaller-samples"
# OBJECT_NAME: "STEP-FUNCTION-WILL-PROVIDE" - full filename, eg: G6RV5.start.tar.gz
# SAMPLE_ID: "STEP-FUNCTION-WILL-PROVIDE" - sample identifier, eg G6RV5
# SERIAL_WAIT: "TRUE" - setting this to false runs everything in parallel, which will likely require a very large machine to run.

# Download inputs
download "s3://${SAMPLES_BUCKET}/" "${OBJECT_NAME}"
