
# FINOPS.md



# FinOps Strategy

### Principles

The project follows:

- Cost visibility

- Resource optimization

- Waste reduction


## Current Controls

### Resource Tagging

Resources include: 


Project=cloudmovie-challenge

Environment=dev

ManagedBy=Terraform



## Cost Monitoring

Recommended:

AWS Cost Explorer:

- Daily review
- Service breakdown
- Budget alerts

## Current Cost Risks

Highest risk:

1. NAT Gateway
2. ALB
3. EC2 running continuously

## Mitigation

- Run only during demonstrations
- Remove unused infrastructure
- Use free-tier resources

## Future Improvement

Implement:

- AWS Budgets
- Cost Anomaly Detection
- Automated shutdown schedules
