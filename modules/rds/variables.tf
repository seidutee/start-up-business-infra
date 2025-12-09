variable "resourceprefix" {
  description = "Prefix for naming AWS resources"
  type        = string
}

variable "engine" {
  description = "Database engine (e.g., mysql, postgres)"
  type        = string
  default     = "mysql"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS instance type for master"
  type        = string
  default     = "db.t3.micro"
}

variable "replica_instance_class" {
  description = "RDS instance type for replica"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "Database master username"
  type        = string
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "allocated_storage" {
  description = "Storage in GB for the RDS master"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type (gp2, gp3, io1)"
  type        = string
  default     = "gp3"
}

variable "multi_az" {
  description = "Whether to create a multi-AZ RDS master"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to keep backups"
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on deletion"
  type        = bool
  default     = true
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for RDS"
  type        = list(string)
}

variable "db_sg_id" {
  description = "Security Group ID for RDS"
  type        = string
}

variable "node_type" {
  description = "Instance type for any associated resources"
  type        = string
  default     = "t3.micro"
}

variable "num_cache_nodes" {
  description = "Number of cache nodes for ElastiCache"
  type        = number
  default     = 2
}

variable "cache_port" {
  description = "Port for ElastiCache Memcached"
  type        = number
  default     = 11211
}

variable "memcached_sg_ids" {
  description = "Security Group IDs for Memcached"
  type        = list(string)
}