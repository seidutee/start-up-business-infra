output "db_username_ssm_parameter_arn" {
  description = "The ARN of the SSM parameter storing the database username"
  value       = aws_ssm_parameter.db_username.arn
}

output "db_password_ssm_parameter_arn" {
  description = "The ARN of the SSM parameter storing the database password"
  value       = aws_ssm_parameter.db_password.arn
}

output "db_username_ssm_parameter_name" {
  description = "The name of the SSM parameter storing the database username"
  value       = aws_ssm_parameter.db_username.name
}

output "db_password_ssm_parameter_name" {
  description = "The name of the SSM parameter storing the database password"
  value       = aws_ssm_parameter.db_password.name
}
