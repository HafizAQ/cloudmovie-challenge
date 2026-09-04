
# CloudMovie Challenge Architecture

## Overview

CloudMovie Challenge is a cloud-native Flask application that allows users to guess movie titles from emoji clues.

The platform demonstrates AWS infrastructure provisioning, container deployment, CI/CD automation, monitoring and operational best practices.

## Architecture Flow

Internet
	|
	|
Application Load Balancer
	|
	|
EC2 Auto Scaling Group
	|
	|
Docker Container
	|
	|
Flask Application

Supporting Services:

- Amazon ECR
- Amazon DynamoDB
- AWS Secrets Manager
- AWS Lambda
- Amazon CloudWatch
- Amazon SNS
- Terraform
- GitHub Actions

## Infrastructure Decisions

### Networking

- Custom VPC
- Public and private subnets
- Internet Gateway
- NAT Gateway
- S3 Gateway Endpoint

### Compute

Application runs on:

- EC2 Amazon Linux 2023
- Auto Scaling Group
- Docker container
- ECR image deployment

### Database

Leaderboard uses:

- DynamoDB
- On-demand capacity mode

### Security

Implemented:

- IAM least privilege
- Secrets Manager for TMDB token
- Security groups
- No hardcoded credentials

### Observability

Implemented:

- CloudWatch dashboard
- CloudWatch alarms
- SNS notifications
- Logs Insights queries

### CI/CD

Pipeline:

GitHub Push

	↓

GitHub Actions

	↓

Docker Build

	↓

Amazon ECR

	↓

ASG Instance Refresh

	↓

ALB Health Check
