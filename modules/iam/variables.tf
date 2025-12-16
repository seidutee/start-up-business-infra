variable "admin_role_principals" {
  type        = list(string)
  description = "List of IAM service principals that can assume the admin role (e.g., [\"ec2.amazonaws.com\"])"
  default     = ["ec2.amazonaws.com"]
}

variable "company_name" {
  type        = string
  description = "Company prefix used for resource names"
  default     = "CBG"
}

variable "env" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
  default     = "dev"
}

variable "instance_profile_name" {
  type        = string
  description = "Name to assign to the IAM instance profile (optional)"
  default     = "CBG-dev-rbac-instance-profile"
}

variable "ResourcePrefix" {
  type        = string
  description = "Prefix to use for all resources"
  default     = "CBG-dev"
}

variable "operations_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket used for operations"
}

variable "replication_destination_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket used for replication"
}