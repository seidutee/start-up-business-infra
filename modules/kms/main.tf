resource "aws_kms_key" "dev_CBG" {
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
}

resource "aws_kms_alias" "shaafi_CBG_Dev" {
  name          = "alias/${var.alias}"
  target_key_id = aws_kms_key.dev_CBG.key_id
}
