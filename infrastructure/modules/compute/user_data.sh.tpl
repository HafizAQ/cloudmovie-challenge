#!/bin/bash

set -euxo pipefail

dnf install -y docker

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
    --env AWS_REGION="${aws_region}" \
    "${ecr_repository_url}:latest"

    