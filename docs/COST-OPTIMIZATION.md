
# Cost Optimization Strategy

## Objective

Build a production-style architecture while remaining within AWS Free Tier and limited credits.

## Compute

### EC2

Optimization:

- Single instance deployment
- Auto Scaling minimum capacity = 1
- Stop resources when not demonstrating

## Lambda

Configuration:

- ARM64 architecture
- 128MB memory
- Reserved concurrency removed

Reason:

Avoid unnecessary charges.

## DynamoDB

Configuration:

- On-demand billing

Reason:

No idle capacity cost.

## CloudWatch

Optimization:

Application logs retention: 3 days 


Reason:

Avoid unnecessary storage charges.

## ECR

Lifecycle policy:

Remove unused images.

## NAT Gateway

NAT Gateway is expensive.

Usage:

- Demonstration only
- Not continuously running

## General Practices

- Delete unused resources
- Review Cost Explorer weekly
- Use Terraform destroy after experiments
