#!/bin/bash -e

if [[ ${JOB_TYPE} == 'CHILD' ]]
then
  PARENT_RESULTS_PATH="/scratch/results/${SAMPLE_ID}/${PARENT_AWS_BATCH_JOB_ID}/${PARENT_AWS_BATCH_JOB_ATTEMPT}/${SAMPLE_ID}"
  echo "Starting intSiteCaller child job..."
  echo "cd $PARENT_RESULTS_PATH && eval conda run -vvv -n intSiteCaller ${RUN_COMMAND}"
  cd "$PARENT_RESULTS_PATH" && eval conda run -n intSiteCaller "${RUN_COMMAND}"
else
  CHILD_RESULTS_PATH="/scratch/results/${SAMPLE_ID}/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}/${SAMPLE_ID}"
  echo "Starting intSiteCaller parent job..."
  echo "cd $CHILD_RESULTS_PATH && eval conda run -vvv -n intSiteCaller ${RUN_COMMAND}"
  cd "$CHILD_RESULTS_PATH" && eval conda run -n intSiteCaller "${RUN_COMMAND}"
  echo "intSiteCaller run complete...proceeding with post-run actions."
  # need to block until all child jobs are done....
fi