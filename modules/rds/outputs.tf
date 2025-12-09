output "rds_master_endpoint" {
  description = "Endpoint of the primary RDS instance"
  value       = aws_db_instance.rds_master.endpoint
}

output "rds_replica_endpoint" {
  description = "Endpoint of the read replica"
  value       = aws_db_instance.rds_replica.endpoint
}

output "rds_master_arn" {
  description = "ARN of the master RDS instance"
  value       = aws_db_instance.rds_master.arn
}

output "rds_replica_arn" {
  description = "ARN of the read replica instance"
  value       = aws_db_instance.rds_replica.arn
}
