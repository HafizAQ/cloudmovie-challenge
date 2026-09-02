
# CloudMovie Challenge is a containerised Flask application

running on AWS using Terraform-managed infrastructure.

The design follows cloud-native principles:

- private compute
- immutable containers
- IAM-based security
- managed AWS services
- automated deployment


# Architecture Diagram 

Include: 


VPC

Public subnet:
ALB

Private subnet:
EC2 ASG

AWS services:
ECR
DynamoDB
Secrets Manager
CloudWatch
