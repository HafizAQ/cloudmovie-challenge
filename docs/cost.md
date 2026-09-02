# CloudMovie Challenge — Cost and Optimisation Strategy

## Objective

CloudMovie Challenge was built as a short-lived educational development environment.

The infrastructure therefore needs to demonstrate realistic cloud patterns without consuming unnecessary AWS credit.

The main cost strategy is:

> Keep the architecture representative, but keep runtime capacity small and destroy paid resources when they are not needed.

---

## Main Cost Drivers

The most important resources to monitor are:

- NAT Gateway
- Application Load Balancer
- EC2
- Secrets Manager
- ECR storage
- CloudWatch logs

DynamoDB usage for this project is comparatively small.

---

## EC2

### Development Configuration

The application uses a small EC2 instance type.

The Auto Scaling Group is configured with a small desired capacity for the demo environment.

Typical development approach:

```text
min      = 1
desired  = 1
max      = 2
```

The second instance capacity is available for replacement/deployment behaviour rather than continuous operation.

### Trade-Off

A single continuously running application instance is cheaper but provides less availability than a production deployment with two or more instances.

### Production Recommendation

Use at least two application instances distributed across Availability Zones.

---

## Application Load Balancer

The ALB provides:

- Public ingress
- Health checks
- Target registration
- Multi-AZ routing
- Auto Scaling integration

The ALB has an ongoing cost while provisioned.

### Cost Strategy

Keep the ALB only while the capstone environment is required.

Destroy the environment when demonstrations are complete.

---

## NAT Gateway

The NAT Gateway is one of the most important cost considerations.

It incurs:

- Hourly cost
- Data processing cost

### Why It Exists

The private EC2 application must call the external TMDB API.

Therefore:

```text
Private EC2
   |
   v
NAT Gateway
   |
   v
TMDB API
```

### Development Optimisation

Only one NAT Gateway is used.

This reduces cost compared with a production architecture using one NAT Gateway per Availability Zone.

### Trade-Off

A single NAT Gateway reduces egress high availability.

### Production Recommendation

For higher availability, use NAT Gateways per AZ or redesign outbound access based on workload requirements.

---

## S3 Gateway VPC Endpoint

An S3 Gateway Endpoint is used for private S3 connectivity.

### Benefit

S3 traffic does not need to travel through the NAT Gateway.

This:

- Reduces NAT processing
- Keeps AWS service traffic on the AWS network
- Provides a useful cost-optimisation example

Gateway endpoints for S3 do not carry the same hourly pricing model as NAT Gateway.

---

## DynamoDB

The leaderboard uses DynamoDB.

The workload is small and predictable.

### Cost Strategy

Use minimal provisioned capacity or an appropriately selected low-cost mode for the demo environment.

DynamoDB avoids:

- RDS instance cost
- Database server administration
- Persistent database compute

This makes it suitable for the simple leaderboard workload.

---

## Amazon ECR

ECR stores Docker images.

### Cost Risks

Repeated CI/CD runs can accumulate image layers and old image versions.

### Optimisation

Use:

- A small image based on `python:3.12-slim`
- `.dockerignore`
- ECR lifecycle rules if many old images accumulate
- Limited unnecessary rebuilds

The GitHub Actions workflow can also use path filtering so documentation-only commits do not trigger application deployments.

---

## Secrets Manager

The project stores one TMDB API token.

Secrets Manager introduces a small ongoing cost per secret.

The security benefit is considered worthwhile because it demonstrates proper credential management.

The secret value is not stored in:

- Git
- Docker image
- Terraform configuration
- Terraform state

---

## CloudWatch

CloudWatch provides observability.

Potential cost sources include:

- Log ingestion
- Log storage
- Custom metrics
- Dashboards

### Optimisation

For a short-lived capstone:

- Keep log volume small
- Set reasonable log retention
- Avoid unnecessary high-frequency custom metrics
- Use only the dashboards and alarms needed for the demonstration

---

## Terraform State

Terraform remote state is stored in S3.

State files are small, so storage cost is minimal.

Versioning improves recoverability.

Terraform's S3-native state locking is used instead of provisioning a separate DynamoDB state-lock table.

---

## CI/CD Cost Control

The GitHub Actions deployment workflow should not deploy on every repository change.

Recommended path filter:

```yaml
paths:
  - "app/**"
  - ".github/workflows/deploy.yml"
```

This prevents changes such as:

```text
docs/*
README.md
```

from unnecessarily rebuilding the container and refreshing the Auto Scaling Group.

---

## Ephemeral Environment Strategy

The most effective cost control is to destroy the AWS runtime when it is no longer required.

Before destroying:

1. Capture screenshots
2. Complete the demo
3. Confirm documentation
4. Verify Terraform state

Then:

```bash
cd infrastructure/environments/dev

terraform plan   -destroy   -out=destroy.tfplan

terraform apply destroy.tfplan
```

Terraform can later recreate the environment.

---

## Development vs Production

| Area | Development / Capstone | Production |
|---|---|---|
| EC2 capacity | 1 desired instance | 2+ instances |
| NAT | Single NAT Gateway | NAT per AZ or workload-specific design |
| ALB | HTTP demo | HTTPS with ACM |
| Domain | ALB DNS | Route 53 custom domain |
| Secrets | 1 TMDB secret | Environment-specific secrets |
| Deployment | ASG refresh | Versioned immutable deployment + rollback |
| Monitoring | Essential dashboard/alarms | Full SLO-oriented monitoring |
| Environment lifetime | Ephemeral | Persistent |

---

## Cost-Aware Architecture Summary

The project intentionally does **not** remove important architectural components merely to minimise cost.

Instead, it demonstrates the components while reducing their scale.

Examples:

```text
ALB
kept because it demonstrates controlled public ingress

NAT Gateway
kept because private EC2 genuinely requires external TMDB access

DynamoDB
chosen instead of RDS because the workload does not justify relational database compute

S3 Gateway Endpoint
added to avoid unnecessary NAT processing

ASG desired capacity = 1
used as a development cost compromise

Terraform destroy
used as the primary idle-cost control
```

This provides a stronger engineering story than either overspending on a production-sized environment or removing the architecture required to demonstrate the relevant cloud patterns.
