# CloudMovie Challenge — Architecture

## Overview

CloudMovie Challenge is a containerised Flask application deployed on AWS using Terraform.

The architecture was designed to demonstrate production-oriented cloud engineering patterns while keeping the development environment small enough for a short-lived capstone project.

The core design principles are:

- Infrastructure as Code with Terraform
- Private application compute
- Public access only through an Application Load Balancer
- Containerised application delivery using Docker and Amazon ECR
- Persistent state stored outside EC2
- IAM-based access instead of static credentials on instances
- Secrets stored in AWS Secrets Manager
- Private instance administration through AWS Systems Manager
- Monitoring and alarms through Amazon CloudWatch
- Automated application deployment through GitHub Actions
- Explicit cost-control trade-offs for the development environment

---

## High-Level Architecture

```text
                            Internet
                               |
                               v
                  Application Load Balancer
                     Public Subnets / Multi-AZ
                               |
                               v
                    Auto Scaling Group
                     Private Subnets
                               |
                         EC2 Instances
                               |
                    Docker / Gunicorn / Flask
                               |
          +--------------------+--------------------+
          |                    |                    |
          v                    v                    v
     Amazon ECR            DynamoDB          Secrets Manager
                                                |
                                                | TMDB token
                                                v
                                         NAT Gateway
                                                |
                                                v
                                           TMDB API

Additional platform services:

- AWS Systems Manager for instance administration
- Amazon CloudWatch for metrics, logs, dashboards and alarms
- S3 Gateway VPC Endpoint for private S3 access
- GitHub Actions for CI/CD
- Terraform remote state stored in Amazon S3
```

---

## Network Design

The application runs inside a custom VPC in `eu-central-1`.

The VPC uses multiple Availability Zones and contains both public and private subnets.

### Public Subnets

Public subnets contain:

- Application Load Balancer
- NAT Gateway

The public route table has a default route to the Internet Gateway.

### Private Subnets

Private subnets contain:

- EC2 instances managed by the Auto Scaling Group

The EC2 instances do not receive public IP addresses.

Outbound Internet access from the private application tier is routed through the NAT Gateway when external access is required, including communication with the TMDB API.

An S3 Gateway Endpoint is attached to the private route table so S3 traffic does not need to traverse the NAT Gateway.

---

## Application Entry Point

The Application Load Balancer is the only public application entry point.

```text
Internet
   |
   v
ALB :80
   |
   v
Target Group :5000
   |
   v
Private EC2
```

The ALB performs health checks against:

```text
/health
```

on application port `5000`.

The EC2 security group permits application traffic only from the ALB security group.

---

## Compute Layer

The application runs on Amazon Linux 2023 EC2 instances managed by an Auto Scaling Group.

The launch template:

- Uses a dynamically resolved Amazon Linux 2023 AMI
- Requires IMDSv2
- Uses an EC2 instance profile
- Uses the application security group
- Runs instances without public IP addresses
- Executes bootstrap logic through `user_data`

During bootstrap, the instance:

1. Installs Docker
2. Starts the Docker service
3. Authenticates to Amazon ECR
4. Pulls the application image
5. Starts the CloudMovie container
6. Passes required runtime environment variables to the container

The application container runs Flask through Gunicorn on port `5000`.

---

## Container Registry

Amazon ECR stores the CloudMovie Docker image.

Repository:

```text
cloudmovie-challenge-dev
```

The EC2 IAM role has permission to pull images from ECR.

The deployment pipeline builds the Docker image and pushes the `latest` image to ECR before triggering an Auto Scaling Group instance refresh.

---

## Persistent State

DynamoDB stores leaderboard data independently of EC2 instances.

This allows the application compute layer to remain disposable.

If an EC2 instance is terminated and replaced, leaderboard data remains available.

The application EC2 role receives only the DynamoDB permissions required by the application, such as:

- `dynamodb:GetItem`
- `dynamodb:PutItem`
- `dynamodb:Scan`

---

## Secrets Management

The TMDB API Read Access Token is stored in AWS Secrets Manager.

Terraform creates:

- The secret container
- IAM access permissions

Terraform does **not** manage the secret value.

The secret value is inserted separately so that it is not stored in Terraform configuration or Terraform state.

At runtime:

```text
EC2 IAM Role
     |
     v
Secrets Manager
     |
     v
TMDB token
     |
     v
Application
```

The application then uses the token to call the TMDB API.

---

## External API Connectivity

The EC2 instances are private and therefore do not communicate directly with the Internet.

Outbound requests to TMDB use:

```text
Private EC2
   |
   v
Private Route Table
   |
   v
NAT Gateway
   |
   v
Internet Gateway
   |
   v
TMDB API
```

This provides a concrete justification for the NAT Gateway in the architecture.

---

## Administration

The EC2 instances do not expose SSH.

AWS Systems Manager Session Manager / Run Command is used instead.

Benefits include:

- No SSH port exposure
- No SSH key distribution
- IAM-controlled administrative access
- Better auditability

---

## Observability

CloudWatch provides operational visibility.

The project includes:

- Application/instance log collection
- ALB metrics
- Target health monitoring
- CloudWatch dashboard
- CloudWatch alarms

This allows application and infrastructure health to be observed without direct server access.

---

## CI/CD

GitHub Actions performs application deployment.

```text
Push to main
    |
    v
GitHub Actions
    |
    +--> Build Docker image
    |
    +--> Authenticate to ECR
    |
    +--> Push image
    |
    +--> Start ASG instance refresh
    |
    v
Replacement EC2 pulls new image
```

The workflow waits for the instance refresh to complete so deployment failure can fail the GitHub Actions job.

---

## Availability Design

The infrastructure spans multiple Availability Zones.

The ALB is deployed across public subnets in multiple AZs.

The Auto Scaling Group can place application instances across private subnets.

For the capstone development environment, the ASG intentionally uses a small desired capacity to control cost.

A production environment would normally run at least two application instances so a single instance failure or deployment does not reduce application capacity.

---

## Security Summary

Key security controls include:

- EC2 instances in private subnets
- No public IP addresses on application instances
- No SSH ingress
- ALB is the only public application entry point
- Application SG accepts port `5000` only from the ALB SG
- IAM instance role instead of embedded AWS credentials
- Secrets Manager for the TMDB token
- IMDSv2 required
- ECR image scanning
- Terraform-managed security controls
- SSM for administrative access

---

## Cost-Aware Design

The project intentionally balances architecture quality with capstone cost constraints.

Cost decisions include:

- Small EC2 instance type
- ASG desired capacity of one for the demo environment
- Single NAT Gateway instead of one NAT Gateway per AZ
- S3 Gateway Endpoint to avoid unnecessary NAT traffic
- Small DynamoDB capacity
- One Secrets Manager secret
- Ephemeral development environment
- Terraform destroy capability after demonstrations

The single NAT Gateway and single running application instance are intentional development-environment compromises, not production recommendations.

---

## Production Improvements

For a real production environment, the following improvements would be appropriate:

- HTTPS listener with ACM certificate
- Route 53 custom domain
- Minimum two application instances
- NAT Gateway per Availability Zone or redesigned endpoint strategy
- More granular CloudWatch alarms
- AWS WAF in front of the ALB
- ECR immutable image tags instead of relying only on `latest`
- Deployment by image digest or versioned tag
- Automated rollback
- Dedicated production Terraform environment
- CI/CD federation with GitHub OIDC instead of long-lived AWS access keys
