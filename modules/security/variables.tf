variable "ResourcePrefix" {
  description = "Prefix for naming resources"
  type        = string
}

variable "public_sg_source_cidr" {
  description = "Source CIDR blocks for public security group ingress rules"
  type        = list(string)
}

variable "public_sg_destination_cidr" {
  description = "Destination CIDR blocks for public security group egress rules"
  type        = list(string)
}

variable "private_sg_destination_cidr" {
  description = "Destination CIDR blocks for private security group egress rules"
  type        = list(string)
}

variable "alb_sg_source_cidr_80" {
  description = "Source CIDR blocks for ALB security group ingress on port 80"
  type        = list(string)
}

variable "alb_sg_source_cidr_443" {
  description = "Source CIDR blocks for ALB security group ingress on port 443"
  type        = list(string)
}

variable "alb_sg_destination_cidr" {
  description = "Destination CIDR blocks for ALB security group egress rules"
  type        = list(string)
}

variable "web_sg_destination_cidr" {
  description = "Destination CIDR blocks for web security group egress rules"
  type        = list(string)
}

variable "app_sg_destination_cidr" {
  description = "Destination CIDR blocks for app security group egress rules"
  type        = list(string)
}

variable "db_sg_destination_cidr" {
  description = "Destination CIDR blocks for DB security group egress rules"
  type        = list(string)
}

variable "efs_sg_description" {
  description = "Description for EFS security group"
  type        = string
}

variable "efs_source_cidr" {
  description = "Source CIDR blocks for EFS security group ingress rules"
  type        = string
}

variable "efs_destination_cidr" {
  description = "Destination CIDR blocks for EFS security group egress rules"
  type        = string
}

variable "nfs_sg_description" {
  description = "Description for NFS security group"
  type        = string
}

variable "nfs_source_cidr" {
  description = "Source CIDR blocks for NFS security group ingress rules"
  type        = string
}

variable "nfs_destination_cidr" {
  description = "Destination CIDR blocks for NFS security group egress rules"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where security groups will be created"
  type        = string
}

variable "monitoring_sg_ingress_rules" {
  description = "List of ingress rules for the monitoring security group."
  type = list(object({
    description = optional(string)
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string), [])
  }))
}
 
variable "monitoring_sg_egress_rules" {
  description = "List of egress rules for the monitoring security group."
  type = list(object({
    description = optional(string)
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = optional(list(string), [])
  }))
  
}
 
