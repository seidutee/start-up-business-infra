##########################
#        VARIABLES       #
##########################

variable "ResourcePrefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "public_subnet_cidr" {
  description = "List of CIDRs for public subnets (one per AZ)"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "List of CIDRs for private subnets (one per AZ)"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "public_ip_on_launch" {
  description = "Assign public IPs on launch for public subnets"
  type        = bool
  default     = true
}

variable "PublicRT_cidr" {
  description = "Public route destination CIDR"
  type        = string
  default     = "0.0.0.0/0"
}

variable "create_nat_gateway" {
  description = "Whether to create NAT Gateways and EIPs (one per AZ)"
  type        = bool
  default     = true
}
