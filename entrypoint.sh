#!/bin/bash -e

exec_dir=/scratch/${AWS_BATCH_JOB_ID}/${AWS_BATCH_JOB_ATTEMPT}; mkdir -p ${exec_dir}; cd ${exec_dir}

pre-run.sh ${exec_dir}

run.sh $@

post-run.sh ${exec_dir}

cd /scratch
rm -rf ${AWS_BATCH_JOB_ID}
