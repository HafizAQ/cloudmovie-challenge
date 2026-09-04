# Solution 3: Container Registry, Docker Validation, Security Controls and Terraform State Management

## Objective

The purpose of this solution was to prepare the CloudMovie Challenge
project for a production-style container deployment workflow by:

-   Creating and validating an Amazon ECR private container registry
-   Building and testing the Docker container locally
-   Managing secure GitHub Actions configuration
-   Implementing branch protection rules
-   Creating an S3 backend for Terraform remote state management
-   Validating security scanning and image storage

------------------------------------------------------------------------

# 1. Terraform Remote State Storage with Amazon S3

## Implementation

A dedicated S3 bucket was created to store Terraform state files
remotely.

Benefits:

-   Centralized Terraform state management
-   Safer collaboration between team members
-   State persistence outside the local machine
-   Foundation for CI/CD automation

## AWS Console Verification

The Terraform state bucket was successfully created:

-   Bucket name:
    `cloudmovie-challenge-tfstate-203637464233-eu-central-1`
-   Region: Europe (Frankfurt) `eu-central-1`

Screenshot:

![S3 Bucket Created](33-s3-bucket-aws-console-tfstate-1(3).png)

![Terraform State Structure](34-s3-bucket-aws-console-tfstate-2(2).png)

------------------------------------------------------------------------

# 2. Docker Image Build and Local Validation

## Docker Image

The application container image was built successfully from the project
Dockerfile.

Local image:

    cloudmovie-local:latest

The image was verified in Docker Desktop.

Screenshot:

![Docker Image](35-docker-destop-image-0(1).png)

------------------------------------------------------------------------

## Running Container Test

The container was started locally and validated.

Container details:

-   Application container: `cloudmovie-local`
-   Port mapping: `5000:5000`
-   Status: Running

Screenshot:

![Running Docker Container](36-docker-destop-container-1(1).png)

This confirms the application can run successfully inside a container
before deployment to AWS.

------------------------------------------------------------------------

# 3. GitHub Repository Security Configuration

## GitHub Actions Secrets

Sensitive deployment information was stored securely using GitHub
repository secrets.

Configured secrets:

-   `AWS_ACCESS_KEY_ID`
-   `AWS_SECRET_ACCESS_KEY`
-   `ECR_URL`

Purpose:

-   Avoid exposing credentials in source code
-   Allow automated CI/CD deployment
-   Follow cloud security best practices

Screenshot:

![GitHub Secrets](38-github-secrets-and-variable-management(3).png)

------------------------------------------------------------------------

# 4. Branch Protection Rules

A branch protection policy was implemented for the main branch.

Purpose:

-   Prevent accidental direct changes
-   Improve code review workflow
-   Protect production-ready code

Configured branch:

    main

Screenshot:

![Branch Protection](37-branch-protection-implemented-at-github(3).png)

------------------------------------------------------------------------

# 5. Amazon ECR Private Repository

## Repository Creation

An Amazon Elastic Container Registry (ECR) private repository was
created.

Repository:

    cloudmovie-challenge-dev

Region:

    eu-central-1 (Frankfurt)

Purpose:

-   Secure private storage for Docker images
-   Integration point for AWS deployment pipelines
-   Container image version management

Screenshot:

![ECR Repository](39-amazon-ecr-private-registry-repositories-0(3).png)

------------------------------------------------------------------------

# 6. Container Image Push to ECR

The Docker image was successfully pushed to Amazon ECR.

Image:

    cloudmovie-challenge-dev:latest

Image information:

-   Status: Active
-   Artifact type: Image
-   Size: approximately 70 MB

Screenshot:

![ECR Latest
Image](40-amazon-ecr-private-registry-repositories-cloudmovie-challenge-dev-latest-images-1(3).png)

------------------------------------------------------------------------

# 7. ECR Vulnerability Scanning

Amazon ECR image scanning was completed successfully.

Scan result:

  Severity          Count
  --------------- -------
  Critical              6
  High                  9
  Medium                3
  Low                   1
  Informational         0

The scan provides visibility into container security risks before
deployment.

Screenshot:

![ECR Vulnerability
Scan](41-amazon-ecr-private-registry-repositories-security-vulnerabilities-2(2).png)

## Security Note

The vulnerabilities identified should be reviewed before production
deployment.

Possible improvements:

-   Update base Docker images regularly
-   Remove unnecessary packages
-   Use smaller hardened images
-   Add automated vulnerability scanning into CI/CD pipeline

------------------------------------------------------------------------

# Solution 3 Summary

Completed components:

  Component                           Status
  ----------------------------------- -----------
  Terraform remote backend using S3   Completed
  Docker image creation               Completed
  Local container validation          Completed
  GitHub Actions secrets              Completed
  Main branch protection              Completed
  Amazon ECR private repository       Completed
  Docker image push to ECR            Completed
  Container vulnerability scanning    Completed

This solution establishes the foundation required for a secure AWS
container deployment pipeline for the CloudMovie Challenge project.
