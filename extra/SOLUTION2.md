# SOLUTION2.md --- CloudMovie Challenge Implementation Evidence

## Overview

This document provides implementation evidence for the additional
production features added to the CloudMovie Challenge project:

-   AWS Lambda serverless bonus challenge
-   TMDB API secret management
-   CloudWatch monitoring and observability
-   Custom CloudWatch dashboard
-   CloudWatch alarms with SNS notifications
-   GitHub Actions CI/CD workflows

------------------------------------------------------------------------

# 1. Serverless Bonus Challenge --- AWS Lambda

## Objective

A stateless AWS Lambda function was added to demonstrate serverless
architecture.

The Lambda function:

-   Runs independently from the main application
-   Generates a bonus movie challenge
-   Uses a lightweight Python runtime
-   Sends structured logs to CloudWatch

## Evidence

![TMDB API Secret
exists](docs/screenshots/21-tmdb-api-secret-exists-2.png)

![Lambda Function](docs/screenshots/22-lembda-stateless-function-2.png)

------------------------------------------------------------------------

# 2. Secrets Management

## Objective

Sensitive application credentials are not stored directly in source
code.

AWS Secrets Manager is used to securely store:

-   TMDB API credentials
-   Application secrets

Benefits:

-   Improved security
-   Centralized secret management
-   Easier rotation in production environments

------------------------------------------------------------------------

# 3. CloudWatch Monitoring Setup

## Objective

CloudWatch was configured to provide operational visibility across AWS
services.

Monitored components:

-   Application Load Balancer
-   Lambda
-   DynamoDB
-   Logs
-   Target health

## Custom Metrics

![CloudWatch
Metrics](docs/screenshots/25-cloudwatch-custom-metrics-1.png)

------------------------------------------------------------------------

# 4. CloudWatch Log Management

## Lambda Logs

Lambda execution logs are automatically captured in CloudWatch Logs.

The logs demonstrate:

-   Function invocation
-   Runtime initialization
-   Execution duration
-   Custom application events

![Log Groups](docs/screenshots/26-cloudwatch-log-groups-2.png)

![Log Streams](docs/screenshots/27-cloudwatch-log-stream-3.png)

![Log Events](docs/screenshots/28-cloudwatch-log-event-4.png)

![Log Insights
Query](docs/screenshots/29-cloudwatch-log-insight-demo-0.png)

------------------------------------------------------------------------

# 5. CloudWatch Alarms and Alerting

## Objective

Automated monitoring alerts were implemented using:

-   CloudWatch Alarms
-   Amazon SNS
-   Email notifications

Configured alarms:

### Healthy Target Alarm

Monitors:

-   Application Load Balancer target health

Purpose:

-   Detect unavailable application instances

### HTTP 5xx Error Alarm

Monitors:

-   Application errors from ALB

Purpose:

-   Identify production failures quickly

## Evidence

![CloudWatch Alarm List](docs/screenshots/30-cloudwatch-alarms-5.png)

![Healthy Target Alarm](docs/screenshots/31-cloudwatch-alarms-6.png)

------------------------------------------------------------------------

# 6. SNS Notification Integration

## Objective

CloudWatch alarms publish notifications through SNS.

Notification flow:

    CloudWatch Alarm
            |
            v
    Amazon SNS Topic
            |
            v
    Email Subscription

## Evidence

![SNS
Subscription](docs/screenshots/32-sns-cloudwatch-email-subscription-1.png)

![Alarm State
Notification](docs/screenshots/33-alaram-state-sns-cloudwatch-email-subscription-2.png)

![OK State
Notification](docs/screenshots/34-ok-state-sns-cloudwatch-email-subscription-3.png)

------------------------------------------------------------------------

# 7. CloudWatch Operations Dashboard

## Objective

A custom dashboard was created to provide a single operational view.

Dashboard includes:

-   Estimated AWS costs
-   ALB requests
-   Target health
-   DynamoDB consumption
-   Application errors

## Evidence

![Dashboard
Overview](docs/screenshots/23-cloudwatch-dashboards-app-aws-console-0.png)

![FinOps
Dashboard](docs/screenshots/24-finops-and-operations-dashboard-couldwatch.png)

------------------------------------------------------------------------

# 8. CI/CD Automation with GitHub Actions

## Objective

Automated workflows were implemented to improve deployment reliability.

Implemented workflows:

## Infrastructure CI

Responsibilities:

-   Terraform formatting check
-   Terraform validation
-   Infrastructure quality checks

![Infrastructure
CI](docs/screenshots/35-cicd-githubaction-infrastructure-ci-workflow.png)

------------------------------------------------------------------------

## Application Deployment CD

Responsibilities:

-   Automated deployment workflow
-   Repeatable release process
-   Reduced manual deployment errors

![Deployment
CD](docs/screenshots/36-cicd-githubaction-deploy-cd-workflow.png)

------------------------------------------------------------------------

# 9. Final Architecture Improvements

The final CloudMovie platform demonstrates:

✅ Infrastructure as Code with Terraform\
✅ AWS Lambda serverless capability\
✅ Secure secret management\
✅ CloudWatch monitoring\
✅ Operational dashboards\
✅ Automated alerting\
✅ SNS notifications\
✅ CI/CD automation through GitHub Actions

------------------------------------------------------------------------

# Production Readiness Summary

The project now includes the essential components expected from a modern
cloud engineering workflow:

  Area             Implementation
  ---------------- -----------------------
  Infrastructure   Terraform
  Compute          AWS EC2 + Lambda
  Networking       VPC, ALB, NAT Gateway
  Storage          S3
  Database         DynamoDB
  Security         Secrets Manager
  Monitoring       CloudWatch
  Alerting         SNS
  Automation       GitHub Actions

This implementation demonstrates practical AWS cloud engineering skills
and production-oriented operational practices.
