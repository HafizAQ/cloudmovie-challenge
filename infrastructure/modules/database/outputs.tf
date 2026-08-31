output "table_name" {
  description = "DynamoDB leaderboard table name"
  value       = aws_dynamodb_table.leaderboard.name
}

output "table_arn" {
  description = "DynamoDB leaderboard table ARN"
  value       = aws_dynamodb_table.leaderboard.arn
}
