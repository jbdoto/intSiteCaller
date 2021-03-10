#!/bin/bash -e

put_metric_data() {

  # compute time elapsed
  end_time=$(date +%s%3N)
  time_delta=$(($end_time - ${1}))

  echo "Job took ${time_delta} ms"
  aws cloudwatch put-metric-data --metric-name JobDuration --namespace intSiteCaller --unit Milliseconds --value ${time_delta} --dimensions JobName=${JOB_NAME} --region ${AWS_REGION}
}

echo "Starting ${JOB_NAME}..."

if [[ ${JOB_TYPE} == 'CHILD' ]]
then
  cd /scratch/results/${PARENT_AWS_BATCH_JOB_ID}/${PARENT_AWS_BATCH_JOB_ATTEMPT};
  run.sh $@
else

  start_time=$(date +%s%3N)

  # parent job sets up directories, downloads, uploads, and cleans up.
  exec_dir=/scratch/results/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}; mkdir -p ${exec_dir}; cd ${exec_dir}

  pre-run.sh ${exec_dir}

  run.sh $@

  post-run.sh ${exec_dir}

  # Cardinality of capturing all uniquely named child jobs (ie: Align_Seqs-G6RV5_1..Align_Seqs-G6RV5_60)
  # could be $$$...keep it simple, just tracking parent job, 'intsitecaller'.
  trap 'put_metric_data ${start_time}' exit

fi
