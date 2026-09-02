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
  treat_missing_data  = "breaching"

  dimensions = {
    LoadBalancer = var.load_balancer_arn_suffix
    TargetGroup  = var.target_group_arn_suffix
  }
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
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "ALB Target Health"
          region = var.aws_region
          period = 60
          stat   = "Average"

          metrics = [
            [
              "AWS/ApplicationELB",
              "HealthyHostCount",
              "LoadBalancer",
              var.load_balancer_arn_suffix,
              "TargetGroup",
              var.target_group_arn_suffix
            ],
            [
              ".",
              "UnHealthyHostCount",
              ".",
              ".",
              ".",
              "."
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "ALB Application Traffic"
          region = var.aws_region
          period = 60
          stat   = "Sum"

          metrics = [
            [
              "AWS/ApplicationELB",
              "RequestCount",
              "LoadBalancer",
              var.load_balancer_arn_suffix
            ],
            [
              ".",
              "HTTPCode_Target_5XX_Count",
              ".",
              ".",
              "TargetGroup",
              var.target_group_arn_suffix
            ]
          ]
        }
      },

      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "Target Response Time"
          region = var.aws_region
          period = 60
          stat   = "Average"

          metrics = [
            [
              "AWS/ApplicationELB",
              "TargetResponseTime",
              "LoadBalancer",
              var.load_balancer_arn_suffix,
              "TargetGroup",
              var.target_group_arn_suffix
            ]
          ]
        }
      },

      {
        type   = "log"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          region = var.aws_region
          title  = "Recent Application Logs"
          view   = "table"

          query = "SOURCE '${aws_cloudwatch_log_group.application.name}' | fields @timestamp, @message | sort @timestamp desc | limit 20"
        }
      }
    ]
  })
}
