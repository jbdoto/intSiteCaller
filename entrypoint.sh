#!/bin/bash -e

if [[ ${JOB_TYPE} == 'CHILD' ]]
then
  cd /scratch/results/${PARENT_AWS_BATCH_JOB_ID}/${PARENT_AWS_BATCH_JOB_ATTEMPT};
  run.sh $@
else
  # parent job sets up directories, downloads, uploads, and cleans up.
  exec_dir=/scratch/results/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}; mkdir -p ${exec_dir}; cd ${exec_dir}

  pre-run.sh ${exec_dir}

  run.sh $@

  post-run.sh ${exec_dir}

fi
