output "key_arn" {
  description = "ARN of the KMS key"
  value       = aws_kms_key.dev_CBG.arn
}

output "key_id" {
  description = "ID of the KMS key"
  value       = aws_kms_key.dev_CBG.key_id
}

output "kms_alias_name" {
  description = "The name of the KMS alias"
  value       = aws_kms_alias.shaafi_CBG_Dev.name
}