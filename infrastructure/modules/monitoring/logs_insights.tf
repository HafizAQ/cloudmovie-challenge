resource "aws_cloudwatch_query_definition" "application_errors" {
  name = "${var.project_name}/${var.environment}/application-errors"

  log_group_names = [
    aws_cloudwatch_log_group.application.name
  ]

  query_string = <<-QUERY
    fields @timestamp, @message
    | filter @message like /ERROR|Exception|Traceback| 5[0-9][0-9] /
    | sort @timestamp desc
    | limit 50
  QUERY
}
