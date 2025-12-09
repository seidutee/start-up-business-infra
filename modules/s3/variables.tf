variable "log_bucket_name" {
  description = "Name of the logging bucket"
  type        = string
}

variable "operations_bucket_name" {
  description = "Name of the operations bucket"
  type        = string
}

variable "replication_destination_bucket_name" {
  description = "Name of the replication destination bucket"
  type        = string
}


variable "operations_versioning_status" {
  description = "Versioning status for the operations bucket"
  type        = string
}

variable "replication_versioning_status" {
  description = "Versioning status for the replication destination bucket"
  type        = string
}

variable "ResourcePrefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "logging_prefix" {
  description = "Prefix for logging in the operations bucket"
  type        = string
}

variable "replication_role_arn" {
  description = "ARN of the IAM role used for S3 replication"
  type        = string
}

