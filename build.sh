#!/bin/sh

aws ecr get-login-password --region us-east-1 --profile=jdoto-ab3 | docker login --username AWS --password-stdin 483158796244.dkr.ecr.us-east-1.amazonaws.com
docker build . -t intsitecaller
docker build -f entrypoint.dockerfile . --build-arg BASE_IMAGE=intsitecaller -t intsitecaller
docker tag intsitecaller 483158796244.dkr.ecr.us-east-1.amazonaws.com/intsitecaller:1.0.0
docker push 483158796244.dkr.ecr.us-east-1.amazonaws.com/intsitecaller:1.0.0
