# CloudMovie Challenge — Architecture Decisions

This document records the major design decisions made during the CloudMovie Challenge capstone.

---

## ADR-001 — Terraform for Infrastructure as Code

### Decision

Use Terraform to provision AWS infrastructure.

### Reason

Terraform provides:

- Repeatable infrastructure
- Version-controlled configuration
- Dependency management
- Planning before deployment
- Clear separation between application and infrastructure
- Reproducible development environments

### Alternatives

Manual AWS Console configuration was rejected because it is difficult to reproduce and provides a weak infrastructure engineering story.

CloudFormation was a valid alternative, but Terraform was selected because it was the primary IaC tool used in the project.

---

## ADR-002 — Application Load Balancer as the Public Entry Point

### Decision

Expose the application through an internet-facing Application Load Balancer.

### Reason

The ALB provides:

- Health checks
- Target registration
- Multi-AZ ingress
- Separation between public and private tiers
- Support for Auto Scaling
- A future path to HTTPS

### Rejected Alternative

A public EC2 instance could have served the Flask application directly.

This was rejected because it would:

- Expose the compute instance directly to the Internet
- Reduce scalability
- Make instance replacement visible to users
- Provide no managed load-balancing layer

---

## ADR-003 — EC2 in Private Subnets

### Decision

Run application EC2 instances in private subnets without public IP addresses.

### Reason

The application instances do not need to accept direct Internet traffic.

All inbound application traffic arrives from the ALB.

Administration is performed through Systems Manager rather than SSH.

This reduces the public attack surface.

---

## ADR-004 — Systems Manager Instead of SSH

### Decision

Do not expose TCP port 22.

Use AWS Systems Manager for administrative commands and validation.

### Reason

This avoids:

- Public SSH exposure
- SSH key management
- Bastion host requirements

SSM also provides IAM-controlled access and better operational auditability.

---

## ADR-005 — Docker + Gunicorn on EC2

### Decision

Package the Flask application as a Docker image and run it using Gunicorn.

### Reason

Containers provide:

- Repeatable runtime dependencies
- Consistent local and cloud execution
- Immutable deployment artifacts
- Easier CI/CD integration

Gunicorn is used instead of Flask's development server because it is appropriate for serving a Python web application in a deployed environment.

### Rejected Alternatives

ECS and Kubernetes were intentionally not introduced because the capstone focus was cloud infrastructure rather than container-orchestration complexity.

---

## ADR-006 — Amazon ECR for Container Storage

### Decision

Store application images in Amazon ECR.

### Reason

ECR integrates directly with:

- IAM
- EC2
- GitHub Actions
- AWS-native deployment workflows

It also supports container image scanning.

---

## ADR-007 — Auto Scaling Group for Compute Lifecycle

### Decision

Manage application EC2 instances through an Auto Scaling Group.

### Reason

This demonstrates:

- Self-healing
- Declarative desired capacity
- Instance replacement
- Rolling deployment capability
- Integration with an ALB target group

A self-healing test was performed by terminating an application instance and observing the ASG launch a replacement.

---

## ADR-008 — One Application Instance in Development

### Decision

Use a desired capacity of one in the capstone development environment.

### Reason

The project operates under limited AWS credits.

Running two application instances continuously would increase cost.

### Trade-Off

A single-instance configuration can create a temporary availability gap during some replacement scenarios.

The deployment workflow can temporarily use additional ASG capacity during instance refresh to reduce this risk.

For production, at least two application instances would be preferred.

---

## ADR-009 — DynamoDB for Leaderboard Persistence

### Decision

Store leaderboard data in DynamoDB.

### Reason

The workload is:

- Small
- Key/value oriented
- Low operational complexity
- Well suited to a managed NoSQL service

DynamoDB also keeps application state separate from disposable EC2 compute.

### Rejected Alternative

RDS would add unnecessary database administration and cost for a simple leaderboard.

---

## ADR-010 — Secrets Manager for TMDB Credential

### Decision

Store the TMDB API token in AWS Secrets Manager.

### Reason

The credential must not be:

- Committed to Git
- Embedded in the Docker image
- Hardcoded in application source
- Stored in Terraform configuration

EC2 retrieves the token at runtime using its IAM role.

### Important Implementation Choice

Terraform creates the secret object and IAM policy but does not manage the secret value.

This prevents the credential from being stored in Terraform state.

---

## ADR-011 — NAT Gateway for External TMDB Access

### Decision

Provide outbound Internet access from private EC2 through a NAT Gateway.

### Reason

The application must call the external TMDB API while remaining in private subnets.

This produces the path:

```text
Private EC2
   |
   v
NAT Gateway
   |
   v
Internet
   |
   v
TMDB API
```

### Trade-Off

NAT Gateway has a noticeable hourly and data-processing cost.

For the capstone, one NAT Gateway is used instead of one per Availability Zone.

This is a cost optimisation and reduces egress high availability.

---

## ADR-012 — S3 Gateway Endpoint

### Decision

Add an S3 Gateway VPC Endpoint to the private route table.

### Reason

S3 traffic can remain on the AWS network and does not need to use the NAT Gateway.

This improves architecture quality while reducing NAT processing cost.

---

## ADR-013 — CloudWatch for Observability

### Decision

Use Amazon CloudWatch for metrics, logs, dashboards and alarms.

### Reason

CloudWatch is the native AWS observability platform and integrates directly with ALB and EC2.

It provides enough operational visibility for the project without introducing an additional monitoring stack.

---

## ADR-014 — GitHub Actions for CI/CD

### Decision

Use GitHub Actions to build and deploy the application.

### Deployment Flow

```text
Push to main
   |
   v
Docker build
   |
   v
ECR push
   |
   v
ASG instance refresh
   |
   v
New EC2 instance
   |
   v
Pull latest application image
```

### Reason

This demonstrates an automated software delivery lifecycle tied directly to the repository.

---

## ADR-015 — Instance Refresh for Deployment

### Decision

Trigger an Auto Scaling Group instance refresh after pushing a new image.

### Reason

Pushing a Docker image to ECR alone does not update an already-running EC2 container.

The ASG refresh causes replacement instances to launch and execute `user_data`, pulling the current application image.

This turns the workflow into a real deployment pipeline rather than only an image publishing pipeline.

---

## ADR-016 — Remote Terraform State in S3

### Decision

Store Terraform state remotely in S3.

### Reason

Remote state is:

- Safer than relying only on a developer workstation
- Suitable for CI/CD
- Versionable
- Easier to recover

S3-native Terraform lock files are used instead of the older DynamoDB state-locking pattern.

---

## ADR-017 — Ephemeral Dev Environment

### Decision

Treat the AWS development environment as disposable.

### Reason

Services such as:

- NAT Gateway
- Application Load Balancer
- EC2

continue to incur cost while idle.

Terraform is therefore used to reconstruct the environment when required and destroy it when demonstrations are complete.

---

## Production Differences

The capstone architecture demonstrates production-oriented patterns but intentionally makes development-cost compromises.

For production, I would consider:

- HTTPS with ACM
- Route 53
- Two or more application instances
- NAT redundancy
- AWS WAF
- GitHub OIDC authentication
- Immutable/versioned image tags
- Automated rollback
- Stronger alarms and SLOs
- Separate dev/staging/prod environments
