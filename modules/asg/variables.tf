##############################
# General Configuration
##############################
variable "resource_prefix" {
  description = "Prefix for naming AWS resources (e.g., CBG-Dev)"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name for accessing instances"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile name for EC2 instances"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs for the app servers"
  type        = list(string)
}

##############################
# Storage Configuration
##############################
variable "volume_size" {
  description = "Root volume size in GB"
  type        = number
  default     = 8
}

variable "volume_type" {
  description = "EBS volume type (e.g., gp3, gp2)"
  type        = string
  default     = "gp3"
}

##############################
# Scaling Configuration
##############################
variable "min_size" {
  description = "Minimum number of EC2 instances in the ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of EC2 instances in the ASG"
  type        = number
  default     = 5
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances at launch"
  type        = number
  default     = 2
}

##############################
# Networking Configuration
##############################
variable "subnet_ids" {
  description = "List of subnet IDs for the Auto Scaling Group"
  type        = list(string)
}

