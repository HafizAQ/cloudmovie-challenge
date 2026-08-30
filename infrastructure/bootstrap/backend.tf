terraform {
  backend "s3" {}
}

# Current terraform support the following, the DynamoDB-based backend locking as deprecated with .tflock
# use_lockfile = true
