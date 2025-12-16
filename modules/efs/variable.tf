# ---------------------------------------
# General Configuration
# ---------------------------------------
variable "resource_prefix" {
  description = "Prefix for naming AWS resources (e.g., project or app name)"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, stage, prod)"
  type        = string
}


variable "private_subnet_map" {
  description = "Map of private subnet IDs for EFS mount targets (1 per AZ)"
  type        = map(string)
}


# ---------------------------------------
# EFS Configuration
# ---------------------------------------
variable "efs_encrypted" {
  description = "Enable encryption at rest for the EFS filesystem"
  type        = bool
  default     = true
}

variable "efs_performance_mode" {
  description = "EFS performance mode: generalPurpose or maxIO"
  type        = string
  default     = "generalPurpose"
}

variable "efs_throughput_mode" {
  description = "EFS throughput mode: bursting or provisioned"
  type        = string
  default     = "bursting"
}

# ---------------------------------------
# Lifecycle & Backup
# ---------------------------------------
variable "enable_efs_lifecycle_policy" {
  description = "Whether to enable EFS lifecycle policy"
  type        = bool
  default     = true
}

variable "efs_transition_to_ia" {
  description = "When to transition files to Infrequent Access"
  type        = string
  default     = "AFTER_30_DAYS"
}

variable "enable_efs_backup_policy" {
  description = "Whether to enable AWS Backup policy for EFS"
  type        = bool
  default     = true
}

variable "efs_backup_status" {
  description = "Backup policy status (ENABLED or DISABLED)"
  type        = string
  default     = "ENABLED"
}

variable "efs_sg_id" {
  description = "Security Group ID to associate with EFS mount targets"
  type        = string
}
