# CloudMovie Challenge - Solution Documentation

## 1. Project Overview

**Project Name:** CloudMovie Challenge\
**Type:** Cloud Engineering Capstone Portfolio Project\
**Cloud Provider:** AWS\
**Region:** eu-central-1 (Frankfurt)

This project demonstrates a production-oriented cloud deployment
workflow using Infrastructure as Code, containerization, CI/CD
automation, security practices, monitoring considerations, and AWS
managed services.

The objective was to build a scalable and repeatable deployment
architecture for a movie application while keeping operational costs low
and following cloud engineering best practices.

------------------------------------------------------------------------

# 2. Solution Architecture

The implemented solution follows this flow:

    Developer
       |
       | Git Push
       v
    GitHub Repository
       |
       | GitHub Actions CI/CD
       |
       +----------------+
       |                |
       v                v
    Terraform        Docker Build
    Infrastructure       |
       |                 |
       v                 v
    AWS Resources     Amazon ECR
                          |
                          v
                  Container Image
                          |
                          v
                 Application Deployment

------------------------------------------------------------------------

# 3. Technologies Used

## Cloud Platform

-   Amazon Web Services (AWS)

## Infrastructure as Code

-   Terraform

## Containerization

-   Docker
-   Docker Desktop

## Container Registry

-   Amazon Elastic Container Registry (ECR)

## CI/CD

-   GitHub Actions

## Version Control

-   GitHub

## Application

-   CloudMovie application container

------------------------------------------------------------------------

# 4. AWS Infrastructure Components

## VPC

A dedicated Virtual Private Cloud was created to isolate project
resources.

Configuration: - Custom VPC - Public and private networking components -
Internet Gateway - Route tables - Availability Zone based deployment

Purpose: - Network isolation - Controlled traffic flow - Production-like
architecture

------------------------------------------------------------------------

## Application Load Balancer

An Application Load Balancer was included to demonstrate production
architecture patterns.

Benefits: - Traffic distribution - Health checking - Future scalability
support

Traffic flow:

    Internet
       |
       v
    Application Load Balancer
       |
       v
    Application Target

------------------------------------------------------------------------

## EC2 Instance

An EC2 based deployment option was prepared as part of the
infrastructure design.

Purpose: - Demonstrate compute provisioning - Support container hosting
scenarios - Provide production environment understanding

------------------------------------------------------------------------

## NAT Gateway

A NAT Gateway was included to demonstrate secure outbound internet
access from private resources.

Purpose: - Allow private instances to download updates - Prevent direct
inbound internet exposure

------------------------------------------------------------------------

## AWS Secrets Manager

Secrets management was included following security best practices.

Benefits: - Avoid hard-coded credentials - Centralized secret storage -
Improved security posture

------------------------------------------------------------------------

## Lambda Function

A Lambda feature was added to demonstrate serverless capability.

Purpose: - Show event-driven architecture knowledge - Reduce
infrastructure management requirements

------------------------------------------------------------------------

# 5. Docker Implementation

The application was containerized using Docker.

Docker workflow:

    Application Source Code
              |
              v
          Dockerfile
              |
              v
         Docker Image
              |
              v
          Container

Local validation was performed using Docker Desktop.

Container status:

-   CloudMovie local container running successfully
-   Application exposed through port 5000

------------------------------------------------------------------------

# 6. Amazon ECR Implementation

A private ECR repository was created:

Repository:

    cloudmovie-challenge-dev

Purpose: - Secure Docker image storage - AWS native container registry -
Integration with deployment workflows

Image details:

-   Image tag: latest
-   Artifact type: Image
-   Encryption: AES-256

Security scanning was enabled.

------------------------------------------------------------------------

# 7. CI/CD Pipeline

GitHub Actions was implemented to automate deployment.

Pipeline stages:

    Code Commit
         |
         v
    GitHub Actions Trigger
         |
         v
    Application Tests
         |
         v
    Docker Build
         |
         v
    Push Image to ECR
         |
         v
    Deployment

Successful workflow executions:

-   Deploy CloudMovie
-   Infrastructure CI

------------------------------------------------------------------------

# 8. GitHub Security Configuration

Repository secrets were configured:

-   AWS_ACCESS_KEY_ID
-   AWS_SECRET_ACCESS_KEY
-   ECR_URL

Purpose:

-   Protect sensitive credentials
-   Enable automated deployments
-   Follow DevOps security principles

------------------------------------------------------------------------

# 9. Branch Protection

Main branch protection was configured.

Benefits:

-   Prevent accidental direct changes
-   Improve code quality
-   Encourage controlled changes

------------------------------------------------------------------------

# 10. Security Practices Implemented

Implemented security controls:

-   IAM based AWS authentication
-   GitHub encrypted secrets
-   Private ECR repository
-   Container vulnerability scanning
-   Infrastructure as Code
-   Separation of environments

------------------------------------------------------------------------

# 11. Cost Optimization Strategy

Because this project was developed under limited AWS credits, cost
control was considered.

Implemented approaches:

-   Small resource sizing
-   Terraform controlled infrastructure
-   Avoiding unnecessary always-running resources
-   Container-based deployment
-   Resource cleanup capability

Resources such as ALB, NAT Gateway and EC2 were designed for
demonstration and can be destroyed when not required.

------------------------------------------------------------------------

# 12. Monitoring and Reliability Considerations

The architecture supports:

-   Application health checks
-   Container monitoring
-   AWS CloudWatch integration
-   Logging capability
-   Deployment visibility through GitHub Actions

------------------------------------------------------------------------

# 13. Challenges and Solutions

## Challenge 1: Container Deployment

Problem: Ensuring the application worked consistently between local and
cloud environments.

Solution: Dockerized application with repeatable image builds.

------------------------------------------------------------------------

## Challenge 2: Secure Deployment Credentials

Problem: Avoid exposing AWS credentials.

Solution: Used GitHub Actions encrypted secrets.

------------------------------------------------------------------------

## Challenge 3: Infrastructure Repeatability

Problem: Manual AWS configuration creates inconsistency.

Solution: Terraform Infrastructure as Code.

------------------------------------------------------------------------

# 14. Repository Structure

    cloudmovie-challenge/

    ├── application/
    ├── infrastructure/
    │   ├── environments/
    │   ├── modules/
    │   └── terraform files
    │
    ├── .github/
    │   └── workflows/
    │
    ├── Dockerfile
    ├── README.md
    └── SOLUTION.md

------------------------------------------------------------------------

# 15. Evidence Screenshots

The complete project evidence contains **46 screenshots** covering:

1.  Docker local container execution
2.  AWS ECR repository creation
3.  Docker image push
4.  ECR image details
5.  Vulnerability scanning results
6.  GitHub Actions workflows
7.  Repository secrets configuration
8.  Branch protection configuration
9.  Terraform infrastructure deployment
10. AWS resource validation

Screenshots should be stored in:

    docs/screenshots/

Recommended naming:

    01-docker-container.png
    02-ecr-repository.png
    03-ecr-image.png
    ...
    46-final-deployment.png

------------------------------------------------------------------------

# 16. Final Outcome

The CloudMovie Challenge successfully demonstrates:

-   AWS cloud infrastructure design
-   Terraform automation
-   Docker containerization
-   ECR image management
-   CI/CD implementation
-   Security practices
-   Cost awareness
-   Production-oriented thinking

This project represents a complete cloud engineering workflow from
source code to automated cloud deployment.

------------------------------------------------------------------------

# 17. Future Improvements

Possible enhancements:

-   Kubernetes deployment using EKS
-   Blue/Green deployments
-   HTTPS with ACM certificates
-   Route53 domain integration
-   Full observability stack
-   Automated security scanning in CI pipeline
-   Multi-environment promotion workflow
