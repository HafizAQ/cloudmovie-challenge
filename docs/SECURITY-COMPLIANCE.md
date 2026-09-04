
# Security and Compliance

## Identity and Access Management

Implemented:

- IAM roles
- Least privilege policies
- No permanent credentials inside AWS

## Secrets Management

TMDB API token stored in:

AWS Secrets Manager

Never stored in:

- Source code
- Docker image
- GitHub repository

## Network Security

Implemented:

- VPC isolation
- Security groups
- Private application subnet
- Controlled inbound traffic

## Application Security

Docker:

- Runs as non-root user
- Minimal Python image

## Access Management

EC2 access:

AWS Systems Manager

No SSH exposure.

## Data Protection

Leaderboard contains:

- Player nickname
- Score

No sensitive personal information stored.

## Compliance Considerations

Aligned with:

- AWS Well Architected Framework
- Least privilege principle
- Infrastructure as Code practices
- Secure secret management

## Future Security Improvements

- HTTPS with ACM
- AWS WAF
- GuardDuty
- Security Hub
- Automated vulnerability scanning
