#!/bin/bash -e

upload(){
  
  set -o noglob

  local file=$1
  local directory_path=$2
  # move into exec_dir (where results are) set by entrypoint.sh, compress results:
  echo "Compressing results at ${directory_path} into ${file}..."
  tar -czf "${file}" "${directory_path}"

  echo "Archiving results tar file back to S3 results bucket"
  lfs hsm_archive ${file}

  # wait until archive complete:
  # For a 6.8GB file archiving takes about 3 minutes...
  while : ; do
      # https://docs.aws.amazon.com/fsx/latest/LustreGuide/exporting-files-hsm.html
      REMAINING_FILES=`lfs hsm_action ${file} | grep "ARCHIVE" | wc -l`
      echo "Files remaining: $REMAINING_FILES"
      [[ $REMAINING_FILES -gt 0 ]] || break
      echo "$REMAINING_FILES remaining files to archive...waiting..."
      sleep 10
  done

  echo "Archive complete."

  echo "Releasing results tar file from Lustre filesystem..."
  lfs hsm_release ${file}
  echo "Results release complete."

}

cleanup(){

  # full path to this batch job id, removal won't interfere with other concurrent processing:
  local results_path=$1
  echo "Removing files generated during processing..."
  rm -rf "$results_path"
  echo "Files removed"

  echo "Releasing tar file from Lustre filesystem..."
  lfs hsm_release /scratch/results/${OBJECT_NAME}
  echo "Release complete."
}

# Upload outputs post-parent job
if [[ ${JOB_TYPE} == 'PARENT' ]]
  then
  RESULTS_PATH="/scratch/results/${SAMPLE_ID}/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}"
  # can't have output tar file in the same directory you're compressing...
  upload "$RESULTS_PATH/${SAMPLE_ID}_results.tar.gz" "$RESULTS_PATH/${SAMPLE_ID}"
  cleanup "/scratch/results/${SAMPLE_ID}/${AWS_BATCH_JOB_ID}/"
fi

# Record execution succeeded in CloudWatch
if [[ $STATE_MACHINE_NAME ]]; then
  aws cloudwatch put-metric-data --metric-name ExecutionsSucceeded --namespace intSiteCaller --unit Count --value 1 --dimensions StateMachine=${STATE_MACHINE_NAME} --region ${AWS_REGION}
else
  aws cloudwatch put-metric-data --metric-name ExecutionsSucceeded --namespace intSiteCaller --unit Count --value 1 --region ${AWS_REGION}
fi