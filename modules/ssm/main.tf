resource "aws_ssm_parameter" "db_username" {
  name   = var.db_username_parameter_name
  type   = var.parameter_type
  value  = var.db_username
  key_id = var.kms_key_arn
}

resource "aws_ssm_parameter" "db_password" {
  name   = var.db_password_parameter_name
  type   = var.parameter_type
  value  = var.db_password
  key_id = var.kms_key_arn
}
