
# Architecture Decision Records

# ADR-001: Terraform as Infrastructure Tool

## Decision

Use Terraform for AWS infrastructure provisioning.

## Reason

Terraform provides:

- Infrastructure as Code
- Version control
- Repeatable deployments
- Modular design

---

# ADR-002: EC2 Instead of ECS

## Decision

Deploy application on EC2 Docker container.

## Reason

The project goal was to demonstrate:

- Networking
- Load balancing
- Security groups
- IAM
- Monitoring

ECS would reduce visibility into infrastructure concepts.

---

# ADR-003: DynamoDB Instead of RDS

## Decision

Use DynamoDB for leaderboard storage.

## Reason

Advantages:

- Serverless
- No database administration
- Free-tier friendly
- Suitable for simple key-value workload

---

# ADR-004: Secrets Manager

## Decision

Store TMDB API token in Secrets Manager.

## Reason

Avoid:

- Hardcoded secrets
- Git exposure
- Environment leakage

---

# ADR-005: CloudWatch Monitoring

## Decision

Use native AWS monitoring.

## Reason

Provides:

- Centralized logging
- Metrics
- Alerts
- Debugging capability
