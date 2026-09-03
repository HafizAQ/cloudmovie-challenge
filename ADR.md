
# Architecture Decision Records

## ADR-001: Terraform for Infrastructure

Decision:
Use Terraform for AWS infrastructure provisioning.

Reason:

- Infrastructure as Code
- Repeatability
- Version control
- Easier demonstration

---

## ADR-002: EC2 + Docker instead of ECS

Decision:
Deploy container on EC2 Auto Scaling Group.

Reason:

- Demonstrates networking and compute fundamentals
- Suitable for project scale
- Lower complexity
- Cost conscious

---

## ADR-003: DynamoDB for Leaderboard

Decision:
Use DynamoDB instead of relational database.

Reason:

- Serverless
- Free tier friendly
- Simple key-value workload

---

## ADR-004: Secrets Manager for TMDB Token

Decision:
Store external API credentials in AWS Secrets Manager.

Reason:

- Avoid secrets in code
- IAM controlled access
- Production security practice

---

## ADR-005: NAT Gateway Usage

Decision:
Use one NAT Gateway.

Reason:

- Private subnet internet access
- Demonstrates production networking
- Reduced cost compared to multi-AZ NAT
