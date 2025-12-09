output "rbac_instance_profile" {
  value = aws_iam_instance_profile.rbac_instance_profile.name
}

output "replication_role_arn" {
  value = aws_iam_role.replication_role.arn
}

