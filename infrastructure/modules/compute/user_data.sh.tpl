#!/bin/bash

set -euxo pipefail

dnf install -y docker amazon-cloudwatch-agent

systemctl enable docker
systemctl start docker

REGISTRY_HOST=$(echo "${ecr_repository_url}" | cut -d/ -f1)

aws ecr get-login-password \
    --region "${aws_region}" \
    | docker login \
        --username AWS \
        --password-stdin \
        "$REGISTRY_HOST"

docker pull "${ecr_repository_url}:latest"

docker rm -f cloudmovie || true

docker run \
    --detach \
    --restart unless-stopped \
    --name cloudmovie \
    --publish 5000:5000 \
    --env DYNAMODB_TABLE="${dynamodb_table_name}" \
    --env TMDB_SECRET_ID="${tmdb_secret_arn}" \
    --env AWS_REGION="${aws_region}" \
    "${ecr_repository_url}:latest"

yum install -y amazon-cloudwatch-agent


mkdir -p /opt/aws/amazon-cloudwatch-agent/etc

cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<'CWCONFIG'
${cloudwatch_config}
CWCONFIG

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config \
  -m ec2 \
  -s \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

systemctl start amazon-cloudwatch-agent


