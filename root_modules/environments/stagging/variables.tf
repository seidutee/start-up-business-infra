# variable "resourceprefix" {
#   description = "Prefix for resource names"
#   type        = string
# }

# variable "enable_dns_hostnames" {
#   description = "Enable DNS hostnames in the VPC"
#   type        = bool
#   default     = true
# }

# variable "enable_dns_support" {
#   description = "Enable DNS support in the VPC"
#   type        = bool
# }

# variable "instance_tenancy" {
#   description = "The instance tenancy attribute"
#   type        = string
# }

# variable "pub_subnet_cidr" {
#   description = "List of public subnet CIDR blocks"
#   type        = list(string)
# }

# variable "priv_subnet_cidr" {
#   description = "List of private subnet CIDR blocks"
#   type        = list(string)
# }

# variable "availability_zones" {
#   description = "List of availability zones"
#   type        = list(string)
# }

# variable "pub_ip" {
#   description = "Map public IP on launch"
#   type        = bool
# }

# variable "vpc_cidr" {
#   description = "CIDR block for the VPC"
#   type        = string
# }

# variable "route_cidr_block" {
#   description = "CIDR block for the route"
#   type        = string
# }

# variable "eip_associate_with_private_ip" {
#   description = "Associate EIP with private IP"
#   type        = bool
# }

# variable "priv_route_cidr_block" {
#   description = "CIDR block for the private route"
#   type        = string
# }

# variable "web_instance_count" {
#   description = "Number of web instances"
#   type        = number
# }

# variable "web_ami" {
#   description = "AMI ID for web instances"
#   type        = string
# }

# variable "web_instance_type" {
#   description = "Instance type for web instances"
#   type        = string
# }

# variable "key_name" {
#   description = "Key pair name for instances"
#   type        = string
# }

# variable "app_instance_count" {
#   description = "Number of app instances"
#   type        = number
# }

# variable "app_ami" {
#   description = "AMI ID for app instances"
#   type        = string
# }

# variable "app_instance_type" {
#   description = "Instance type for app instances"
#   type        = string
# }

# variable "db_instance_count" {
#   description = "Number of DB instances"
#   type        = number
# }

# variable "db_ami" {
#   description = "AMI ID for DB instances"
#   type        = string
# }

# variable "db_instance_type" {
#   description = "Instance type for DB instances"
#   type        = string
# }

# variable "alb_scheme" {
#   description = "Scheme for the ALB"
#   type        = string
# }

# variable "enable_deletion_protection" {
#   description = "Enable deletion protection for the ALB"
#   type        = bool
#   default     = false
# }

# variable "public_subnet_cidrs" {
#   description = "CIDR blocks for public subnets"
#   type        = list(string)
# }

# variable "private_subnet_cidrs" {
#   description = "CIDR blocks for private subnets"
#   type        = list(string)
# }






#variables for 4 vpcs
variable "vpcs" {
  description = "List of VPCs with their configurations"
  type = map(object({
    name                     = string
    cidr_block               = string
    enable_dns_hostnames     = bool
    enable_dns_support       = bool
    instance_tenancy         = string
    pub_subnet_cidr          = list(string)
    priv_subnet_cidr         = list(string)
    route_cidr_block         = string
    priv_route_cidr_block    = string
    eip_associate_with_private_ip = string
    availability_zones        = list(string)
  }))
}


