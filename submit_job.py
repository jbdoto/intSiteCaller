import argparse

import boto3

batch = boto3.client(
    service_name='batch',
    region_name='us-east-1',
    endpoint_url='https://batch.us-east-1.amazonaws.com')

cloudwatch = boto3.client(
    service_name='logs',
    region_name='us-east-1',
    endpoint_url='https://logs.us-east-1.amazonaws.com')

parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)

parser.add_argument("--job-name", help="name of the job", type=str, default='intsitecaller')
parser.add_argument("--job-queue", help="name of the job queue to submit this job", type=str, default='intsitecaller-job-queue')
parser.add_argument("--job-definition", help="name of the job job definition", type=str, default="intsitecaller")
parser.add_argument("--run-command", help="command to run", type=str)
parser.add_argument("--bucket-name", help="the name of the source data bucket, eg: intsitecaller-samples", type=str)
parser.add_argument("--object-name", help="the name of the source data tar.gz file, eg: G6RV5.tar.gz", type=str)
parser.add_argument("--sample-id", help="the sample id, eg: G6RV5", type=str)
parser.add_argument("--serial-wait", help="whether the subsequent job should submit commands to the os and wait. ",dest='feature', action='store_true', default=False)
parser.add_argument("--job-type", help="whether this is a parent or child job. ", type=str)
parser.add_argument("--parent-aws-batch-job-id", help="the job id of the parent batch job that started this job", type=str)
parser.add_argument("--parent-aws-batch-job-attempt", help="the job attempt count of the parent batch job that started this job", type=str)

args = parser.parse_args()


def main():

    job_name = args.job_name
    job_queue = args.job_queue
    job_definition = args.job_definition
    run_command = args.run_command
    bucket_name = args.bucket_name
    object_name = args.object_name
    sample_id = args.sample_id
    job_type = args.job_type
    parent_aws_batch_job_id = args.parent_aws_batch_job_id
    parent_aws_batch_job_attempt = args.parent_aws_batch_job_attempt
    print('got args: %s', args)

    submitJobResponse = batch.submit_job(
        jobName=job_name,
        jobQueue=job_queue,
        jobDefinition=job_definition,
        containerOverrides={'environment': [{"name": "RUN_COMMAND", "value": run_command},
                                            {"name": "BUCKET_NAME", "value": bucket_name},
                                            {"name": "OBJECT_NAME", "value": object_name},
                                            {"name": "SAMPLE_ID", "value": sample_id},
                                            {"name": "JOB_TYPE", "value": job_type},
                                            {"name": "PARENT_AWS_BATCH_JOB_ID", "value": parent_aws_batch_job_id},
                                            {"name": "JOB_NAME", "value": job_name},
                                            {"name": "JOB_QUEUE", "value": job_queue},
                                            {"name": "JOB_DEFINITION", "value": job_definition},
                                            {"name": "PARENT_AWS_BATCH_JOB_ATTEMPT",
                                             "value": parent_aws_batch_job_attempt}]}
    )

    jobId = submitJobResponse['jobId']
    print('Submitted job [%s - %s] to the job queue [%s]' % (job_name, jobId, job_queue))

if __name__ == "__main__":
    main()
