#!/bin/bash -e

upload(){
  
  set -o noglob

  local to=$1
  local files=$2
  local directory_path=$3

  for file in ${files}
  do
    # move into exec_dir (where results are) set by entrypoint.sh, compress results:
    echo "Compressing results at ${directory_path} into ${file}..."
    tar -czvf "${file}" "${directory_path}"

    echo "aws s3 cp . ${to} --recursive --exclude \"*\" --include \"${file}\""
    aws s3 cp . ${to} --recursive --exclude "*" --include "${file}"

  done
}

cleanup(){

  echo "Removing files generated during processing..."
  rm -rfv /scratch/results/${AWS_BATCH_JOB_ID}/
  echo "Files removed"

# TODO: this is temporarily disabled because I need to figure out how to correctly install
# lustre 2.12 under debian buster-slim...
#  echo "Releasing tar file from Lustre filesystem..."
#  lfs hsm_release /scratch/results/${OBJECT_NAME}
#  echo "Release complete."
}

# Job results path in job results bucket
if [[ $STATE_MACHINE_NAME ]]; then
  jobresults=${JOBRESULTS_BUCKET}/${SAMPLE_ID}/${STATE_MACHINE_NAME}/${EXECUTION_NAME}
else
  jobresults=${JOBRESULTS_BUCKET}/${1}
fi

# Upload outputs post-parent job
if [[ ${JOB_TYPE} == 'PARENT' ]]
  then
  upload "s3://${jobresults}/" "${SAMPLE_ID}_results.tar.gz" "/scratch/results/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}/${SAMPLE_ID}"
  cleanup
fi

# Record execution succeeded in CloudWatch
if [[ $STATE_MACHINE_NAME ]]; then
  aws cloudwatch put-metric-data --metric-name ExecutionsSucceeded --namespace intSiteCaller --unit Count --value 1 --dimensions StateMachine=${STATE_MACHINE_NAME} --region ${AWS_REGION}
else
  aws cloudwatch put-metric-data --metric-name ExecutionsSucceeded --namespace intSiteCaller --unit Count --value 1 --region ${AWS_REGION}
fi