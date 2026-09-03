resource "aws_cloudwatch_log_group" "application" {
  name              = "/cloudmovie/${var.project_name}-${var.environment}/application"
  retention_in_days = 7

  tags = {
    Name        = "${var.project_name}-${var.environment}-application-logs"
    Environment = var.environment
  }
}


resource "aws_cloudwatch_metric_alarm" "unhealthy_targets" {
  alarm_name          = "${var.project_name}-${var.environment}-no-healthy-targets"
  alarm_description   = "CloudMovie ALB has no healthy application targets"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HealthyHostCount"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 2
  comparison_operator = "LessThanThreshold"
  threshold           = 1
  # treat_missing_data  = "breaching"

  dimensions = {
    LoadBalancer = var.load_balancer_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.alerts.arn
  ]

  treat_missing_data = "notBreaching"
}


resource "aws_cloudwatch_metric_alarm" "target_5xx" {
  alarm_name          = "${var.project_name}-${var.environment}-target-5xx"
  alarm_description   = "CloudMovie backend is returning repeated HTTP 5xx responses"
  namespace           = "AWS/ApplicationELB"
  metric_name         = "HTTPCode_Target_5XX_Count"
  statistic           = "Sum"
  period              = 60
  evaluation_periods  = 2
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 5
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = var.load_balancer_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }
}


resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}-${var.environment}"

  dashboard_body = jsonencode({
    start = "-PT1H"

    widgets = [

      {
        type   = "text"
        x      = 0
        y      = 0
        width  = 24
        height = 3

        properties = {
          markdown = <<-EOT
        # CloudMovie Challenge — FinOps & Operations

        **Cost controls:** t3.micro, desired capacity 1, single NAT Gateway, short log retention, S3 Gateway Endpoint, Lambda on-demand, DynamoDB on-demand.
        EOT
        }
      },

      {
        type   = "metric"
        x      = 0
        y      = 3
        width  = 8
        height = 6

        properties = {
          title  = "Estimated AWS Charges"
          region = "us-east-1"
          view   = "singleValue"
          stat   = "Maximum"
          period = 21600

          metrics = [
            [
              "AWS/Billing",
              "EstimatedCharges",
              "Currency",
              "USD"
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 8
        y      = 3
        width  = 8
        height = 6

        properties = {
          title  = "ALB Requests"
          region = "eu-central-1"
          stat   = "Sum"
          period = 300

          metrics = [
            [
              "AWS/ApplicationELB",
              "RequestCount",
              "LoadBalancer",
              var.load_balancer_arn_suffix
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 16
        y      = 3
        width  = 8
        height = 6

        properties = {
          title  = "Target 5xx Errors"
          region = "eu-central-1"
          stat   = "Sum"
          period = 300

          metrics = [
            [
              "AWS/ApplicationELB",
              "HTTPCode_Target_5XX_Count",
              "LoadBalancer",
              var.load_balancer_arn_suffix
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 0
        y      = 9
        width  = 12
        height = 6

        properties = {
          title  = "Healthy Targets"
          region = "eu-central-1"
          stat   = "Minimum"
          period = 60

          metrics = [
            [
              "AWS/ApplicationELB",
              "HealthyHostCount",
              "LoadBalancer",
              var.load_balancer_arn_suffix,
              "TargetGroup",
              var.target_group_arn_suffix
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 9
        width  = 12
        height = 6

        properties = {
          title  = "DynamoDB Consumption"
          region = "eu-central-1"
          stat   = "Sum"
          period = 300

          metrics = [
            [
              "AWS/DynamoDB",
              "ConsumedReadCapacityUnits",
              "TableName",
              var.dynamodb_table_name
            ],
            [
              "AWS/DynamoDB",
              "ConsumedWriteCapacityUnits",
              "TableName",
              var.dynamodb_table_name
            ]
          ]
        }
      },

      {
        type   = "log"
        x      = 0
        y      = 15
        width  = 24
        height = 7

        properties = {
          title  = "Application Errors — Logs Insights"
          region = "eu-central-1"
          view   = "table"

          query = "SOURCE '${aws_cloudwatch_log_group.application.name}' | fields @timestamp, @message | filter @message like /ERROR|Exception|Traceback| 5[0-9][0-9] / | sort @timestamp desc | limit 20"
        }
      }
    ]
  })
}




