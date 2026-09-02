# CloudMovie Challenge - Live Demo Script

This script is designed for a **2-3 minute live demo** inside a 10-12 minute capstone presentation.

The objective is not to show every AWS console page. The objective is to prove the most important engineering claims quickly and safely.

---

# 1. Pre-demo preparation

Run these commands **before presenting**.

```bash
cd ~/Ironhack/Week9/final-project/cloudmovie-challenge/infrastructure/environments/dev

export AWS_REGION=eu-central-1
export AWS_DEFAULT_REGION=eu-central-1

export ALB_DNS=$(terraform output -raw alb_dns_name)
export ASG_NAME=$(terraform output -raw autoscaling_group_name)
export TG_ARN=$(terraform output -raw target_group_arn)
export ECR_URL=$(terraform output -raw ecr_repository_url)
export SECRET_ARN=$(terraform output -raw tmdb_secret_arn)
```

Verify variables:

```bash
echo "$ALB_DNS"
echo "$ASG_NAME"
echo "$ECR_URL"
```

Run a private sanity check:

```bash
curl -s "http://$ALB_DNS/health"
curl -s "http://$ALB_DNS/api/movie-spotlight"
```

Check target health:

```bash
aws elbv2 describe-target-health \
  --target-group-arn "$TG_ARN" \
  --region eu-central-1 \
  --query 'TargetHealthDescriptions[*].{Instance:Target.Id,State:TargetHealth.State}' \
  --output table
```

Do not begin the live demo until the current target is `healthy`.

---

# 2. Keep these tabs/windows ready

Prepare these before the presentation:

1. Browser tab - CloudMovie application through the ALB
2. Terminal - already in `infrastructure/environments/dev`
3. GitHub Actions - most recent successful deployment
4. CloudWatch dashboard - optional backup evidence
5. DynamoDB table - optional backup evidence

Do **not** open the Secrets Manager secret value during the presentation.

---

# 3. Live demo sequence

## Demo A - Show the application

Open:

```text
http://<ALB-DNS>
```

### Say

> "This is the CloudMovie Challenge application. The important part for this capstone is not the complexity of the Flask application; it is how the application is deployed and operated on AWS. The request reaches an Application Load Balancer, while the application instance itself remains private."

Spend about **20 seconds** here.

---

## Demo B - Prove ALB and application health

Run:

```bash
curl -i "http://$ALB_DNS/health"
```

Point out:

```text
HTTP/1.1 200 OK
```

### Say

> "The ALB uses the same health endpoint to determine whether the private target should receive traffic. A healthy application returns HTTP 200."

Then run:

```bash
aws elbv2 describe-target-health \
  --target-group-arn "$TG_ARN" \
  --region eu-central-1 \
  --query 'TargetHealthDescriptions[*].{Instance:Target.Id,State:TargetHealth.State}' \
  --output table
```

### Say

> "AWS also confirms that the EC2 target behind the load balancer is healthy."

Spend about **30 seconds**.

---

## Demo C - Prove Secrets Manager + NAT + TMDB integration

Run:

```bash
curl -s "http://$ALB_DNS/api/movie-spotlight"
```

You should receive live movie data.

### Say

> "This endpoint demonstrates two important cloud decisions. The TMDB token is not stored in Git or in the Docker image. The private EC2 instance retrieves the token from Secrets Manager using its IAM role, then reaches the external TMDB API through the NAT Gateway."

Then add:

> "This is why the NAT Gateway exists in this architecture - it is not decorative. It provides controlled outbound Internet access for private compute."

Spend about **30-40 seconds**.

---

## Demo D - Prove persistent state

Run:

```bash
aws dynamodb scan \
  --table-name cloudmovie-challenge-dev-leaderboard \
  --region eu-central-1 \
  --output table
```

### Say

> "The leaderboard is stored in DynamoDB rather than on the EC2 instance. This makes the compute layer disposable. Replacing an instance does not remove application state."

Spend about **20 seconds**.

If the table is empty, submit a leaderboard entry before the presentation so the persistence is visible.

---

## Demo E - Show CI/CD evidence

Switch to the GitHub Actions tab and open the latest successful run.

Show the steps:

```text
Checkout
Configure AWS
Build Docker image
Login ECR
Push image
Start ASG instance refresh
Wait for deployment
```

### Say

> "A push to the application path triggers GitHub Actions. The workflow builds the container, pushes it to ECR, and starts an Auto Scaling Group instance refresh. This means ECR publishing is connected to an actual runtime deployment rather than stopping at image storage."

Spend about **30 seconds**.

---

# 4. Self-healing story - explain, do not perform live

Do **not** terminate the only application instance during the final live presentation unless you deliberately have enough time and capacity.

Instead say:

> "I also tested self-healing by terminating an instance managed by the Auto Scaling Group. AWS launched a replacement, the new instance executed user data, pulled the Docker image from ECR, registered with the target group, and became healthy."

Explain the flow:

```text
Instance terminated
      -> ASG detects lost capacity
      -> replacement EC2 launches
      -> Docker starts
      -> image pulled from ECR
      -> ALB health checks pass
      -> traffic resumes to healthy target
```

Mention the real lesson:

> "With desired capacity one, I observed that a replacement can temporarily reduce availability. That is an intentional dev-cost trade-off. In production I would run at least two application instances."

---

# 5. Optional SSM proof

Only use this if the panel asks how you administer private EC2 instances.

Get the current instance:

```bash
INSTANCE_ID=$(aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names "$ASG_NAME" \
  --region eu-central-1 \
  --query 'AutoScalingGroups[0].Instances[0].InstanceId' \
  --output text)
```

Run Docker status through SSM:

```bash
COMMAND_ID=$(aws ssm send-command \
  --instance-ids "$INSTANCE_ID" \
  --document-name "AWS-RunShellScript" \
  --region eu-central-1 \
  --parameters 'commands=["docker ps"]' \
  --query 'Command.CommandId' \
  --output text)

sleep 3

aws ssm get-command-invocation \
  --command-id "$COMMAND_ID" \
  --instance-id "$INSTANCE_ID" \
  --region eu-central-1 \
  --query 'StandardOutputContent' \
  --output text
```

### Say

> "The instance has no public IP and I do not expose SSH. Operational access is performed through Systems Manager using IAM."

---

# 6. Backup plan if the live environment misbehaves

Never spend presentation time debugging AWS live.

If a request fails:

1. Try the command once more.
2. If it still fails, immediately switch to prepared screenshots.
3. Explain what the evidence shows.
4. Continue the presentation.

Useful screenshots to prepare:

- working application
- `/api/movie-spotlight` response
- healthy ALB target
- healthy ASG instance
- DynamoDB leaderboard data
- CloudWatch dashboard
- successful GitHub Actions deployment
- architecture diagram

### Recovery phrase

> "The live environment is a short-lived cost-controlled dev environment, so rather than debug during the presentation I will use the captured validation evidence and continue with the architecture flow."

---

# 7. Things not to expose during the demo

Do not display:

- `AWS_SECRET_ACCESS_KEY`
- TMDB token
- secret value from Secrets Manager
- local `.env` contents
- `terraform.tfvars` if it contains environment-specific sensitive data

The Secrets Manager **name/ARN and metadata** are fine to show. The value is not.

---

# 8. Recommended 2-3 minute demo timing

| Time | Action |
|---:|---|
| 0:00-0:20 | Show application |
| 0:20-0:45 | `/health` + ALB target health |
| 0:45-1:20 | TMDB live endpoint + explain secret/NAT flow |
| 1:20-1:40 | DynamoDB persistence |
| 1:40-2:10 | GitHub Actions deployment |
| 2:10-2:30 | Self-healing explanation |

Stop there. Do not turn the presentation into a tour of the AWS Console.

---

# 9. Final demo closing line

> "The application itself is intentionally small, but the platform around it demonstrates the core cloud-engineering lifecycle: infrastructure as code, private networking, identity-based security, persistent managed state, secrets management, external connectivity, observability, self-healing, and automated deployment."
