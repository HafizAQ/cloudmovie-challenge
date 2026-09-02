#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/../infrastructure/environments/dev"

terraform init -reconfigure -backend-config=backend.hcl
terraform validate
terraform plan -out=tfplan
terraform apply tfplan