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

# Job results path in job results bucket
if [[ $STATE_MACHINE_NAME ]]; then
  jobresults=${JOBRESULTS_BUCKET}/${SAMPLE_ID}/${STATE_MACHINE_NAME}/${EXECUTION_NAME}
else
  jobresults=${JOBRESULTS_BUCKET}/${1}
fi

# Upload outputs
upload "s3://${jobresults}/" "${SAMPLE_ID}_results.tar.gz" "/scratch/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}/${SAMPLE_ID}"

# Record execution succeeded in CloudWatch
if [[ $STATE_MACHINE_NAME ]]; then
  aws cloudwatch put-metric-data --metric-name ExecutionsSucceeded --namespace intSiteCaller --unit Count --value 1 --dimensions StateMachine=${STATE_MACHINE_NAME} --region ${AWS_REGION}
else
  aws cloudwatch put-metric-data --metric-name ExecutionsSucceeded --namespace intSiteCaller --unit Count --value 1 --region ${AWS_REGION}
fi