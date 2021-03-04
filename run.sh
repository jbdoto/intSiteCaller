#!/bin/bash -e

if [[ ${JOB_TYPE} == 'CHILD' ]]
then
  echo "Starting intSiteCaller child job..."
  echo "cd /scratch/results/${PARENT_AWS_BATCH_JOB_ID}/${PARENT_AWS_BATCH_JOB_ATTEMPT}/${SAMPLE_ID} && eval conda run -vvv -n intSiteCaller ${RUN_COMMAND}"
  cd "/scratch/results/${PARENT_AWS_BATCH_JOB_ID}/${PARENT_AWS_BATCH_JOB_ATTEMPT}/${SAMPLE_ID}" && eval conda run -n intSiteCaller "${RUN_COMMAND}"
else
  echo "Starting intSiteCaller parent job..."
  echo "cd /scratch/results/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}/${SAMPLE_ID} && eval conda run -vvv -n intSiteCaller ${RUN_COMMAND}"
  cd "/scratch/results/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}/${SAMPLE_ID}" && eval conda run -n intSiteCaller "${RUN_COMMAND}"
  echo "intSiteCaller run complete...proceeding with post-run actions."
  # need to block until all child jobs are done....
fi