#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/../infrastructure/environments/dev"

terraform plan -destroy -out=destroy.tfplan
terraform apply destroy.tfplan