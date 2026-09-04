# Monitoring Strategy

## CloudWatch Dashboard

Dashboard includes:

## Application Health

Metric: /health endpoint

Purpose:

Confirm availability.

## ALB Monitoring

Metrics:

- Request count
- HTTP 5xx errors
- Target health

## EC2 Monitoring

Metrics:

- CPU utilization
- Status checks

## Logs

Application logs stored: /cloudmovie/cloudmovie-challenge-dev/application

## Logs Insights Queries

### Find Errors

```sql
fields @timestamp, @message
| filter @message like /ERROR/
| sort @timestamp desc
```

### Recent Requests

fields @timestamp, @message
| sort @timestamp desc
| limit 20

### Alerts

SNS notification configured for:

			ALB 5xx errors
			Unhealthy targets

Workflow:

		CloudWatch Alarm
       			|
       			|
      			SNS
       			|
       			|
 		Email Notification

---


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
