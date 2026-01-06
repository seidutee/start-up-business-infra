module "vpc" {
  source = "../../../modules/vpc"

  vpc_cidr             = "10.0.0.0/16"
  ResourcePrefix       = "CBG-Dev"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  public_subnet_cidr = [ "10.0.1.0/24", "10.0.2.0/24"]

  private_subnet_cidr = [ "10.0.3.0/24", "10.0.4.0/24"]

  availability_zones = [  "us-east-1a",  "us-east-1b" ]

  public_ip_on_launch = true
  PublicRT_cidr       = "0.0.0.0/0"
  create_nat_gateway  = false

    

}

module "security" {
  source = "../../../modules/security"

  ResourcePrefix = "CBG-Dev"

  vpc_id = module.vpc.vpc_id

  public_sg_source_cidr       = ["0.0.0.0/0"]
  public_sg_destination_cidr  = ["0.0.0.0/0"]
  private_sg_destination_cidr = ["10.0.0.0/16"]

  alb_sg_source_cidr_80       = ["0.0.0.0/0"]
  alb_sg_source_cidr_443      = ["0.0.0.0/0"]
  alb_sg_destination_cidr     = ["10.0.0.0/16"]

  web_sg_destination_cidr     = ["10.0.0.0/16"]
  app_sg_destination_cidr     = ["10.0.0.0/16"]
  db_sg_destination_cidr      = ["10.0.0.0/16"]

  efs_sg_description          = "EFS security group for CBG-Dev"
  efs_source_cidr             = "10.0.0.0/16"
  efs_destination_cidr        = "10.0.0.0/16"

  nfs_sg_description          = "NFS security group for CBG-Dev"
  nfs_source_cidr             = "10.0.0.0/16"
  nfs_destination_cidr        = "10.0.0.0/16"

  monitoring_sg_egress_rules = [
    {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  monitoring_sg_ingress_rules = [
    {
      description = "Allow Prometheus"
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow Grafana"
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      description = "Allow SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
 

}


# module "iam" {
#   source = "../../../modules/iam"

#   admin_role_principals = ["ec2.amazonaws.com"]
#   company_name          = "CBG"
#   env                   = "dev"
#   instance_profile_name = "CBG-dev-rbac-instance-profile"
#   ResourcePrefix        = "CBG-dev"
#   operations_bucket_arn = module.s3.operations_bucket_arn
  
  
#   replication_destination_bucket_arn = module.s3.replication_destination_bucket_arn
# }



# module "s3" {
#   source = "../../../modules/s3"

#   log_bucket_name               = "cbg-dev-log-bucket"
#   operations_bucket_name        = "cbg-dev-operations-bucket"
#   replication_destination_bucket_name = "cbg-dev-replication-bucket"

#   operations_versioning_status  = "Enabled"
#   replication_versioning_status = "Enabled"

#   ResourcePrefix                = "CBG-Dev"
#   logging_prefix                = "logs/"
#   replication_role_arn          = module.iam.replication_role_arn
# }



# # EC2 Module
module "ec2" {
  source = "../../../modules/ec2"
 
  ResourcePrefix             = "CBG-Dev"
  ami_ids                    = ["ami-068c0051b15cdb816", "ami-02a53b0d62d37a757", "ami-02e3d076cbd5c28fa", "ami-0c7af5fe939f2677f", "ami-04b4f1a9cf54c11d0"]
  ami_names                  = ["AL2023", "AL2", "Windows", "RedHat", "ubuntu"]
  instance_types             = ["t2.micro", "t2.micro", "t2.micro", "t2.micro", "t2.micro"]
  key_name                   = "safoa"
  instance_profile_name      = "admin_role"   #module.iam.rbac_instance_profile
  public_instance_count      = [1, 0, 0, 0, 0]
  private_instance_count     = [0, 0, 0, 0, 0]
 
  tag_value_public_instances = [
    [
      {
        Name        = "app_servers"
        Environment = "Dev"
      },
     
    ],
    [], [], [], []
  ]
 
  tag_value_private_instances = [
    [
      {
        Name        = "db1"
        Environment = "Dev"
      }],
    [
      {
        Name = "db1"
        Tier = "Database"
      }
    ],
    [],
    [], []
  ]
 
  vpc_id                     = module.vpc.vpc_id
  public_subnet_ids          = module.vpc.public_subnet_ids
  private_subnet_ids         = module.vpc.private_subnet_ids 
  public_sg_id               = module.security.web_sg_id
  private_sg_id              = module.security.db_sg_id
  volume_size                = 8
  volume_type                = "gp3"
  user_data_public           = file("${path.module}/../../../scripts/public_userdata.sh") # Update the user_data script as needed
  user_data_private          = file("${path.module}/../../../scripts/private_userdata.sh")

}

# Add Auto Scaling Group module using the ASG variables
# module "asg" {
#   source = "../../../modules/asg"

#   resource_prefix      = "CBG-Dev"
#   ami_id               = "ami-08b5b3a93ed654d19"           # pick the AMI you want the ASG to use
#   instance_type        = "t3.micro"
#   key_name             = "safoa"
#   iam_instance_profile = module.iam.rbac_instance_profile  # uses IAM module's instance profile
#   security_group_ids   = [module.security.web_sg_id]       # use existing security group

#   volume_size          = 8
#   volume_type          = "gp3"

#   min_size             = 1
#   max_size             = 3
#   desired_capacity     = 1

#   subnet_ids           = module.vpc.public_subnet_ids
# }

 

  
 
 
  
#   module "efs" {

#   source = "../../../modules/efs"

#   resource_prefix     = "CBG-dev"
#   environment         = "dev"
#   private_subnet_map  = module.vpc.private_subnet_map
#   efs_sg_id          = module.security.efs_sg_id
  
#   # efs configuration variables
#   efs_performance_mode      = "generalPurpose"
#   efs_encrypted              = true
#   enable_efs_backup_policy   = true
#   efs_backup_status          = "ENABLED"
#   enable_efs_lifecycle_policy = true
#   efs_transition_to_ia       = "AFTER_30_DAYS"
# }





# module "alb" {
#   source = "../../../modules/alb"

#   environment           = "dev"
#   resource_prefix       = "CBG-Dev"
#   vpc_id                = module.vpc.vpc_id
#   subnet_ids            = module.vpc.public_subnet_ids
#   security_group_ids    = [module.security.alb_sg_id]

#   internal               = false
#   enable_deletion_protection = false
# # target group settings
#   target_type            = "instance"
#   target_protocol        = "HTTP"
#   health_check_enabled   = true
#   health_check_healthy_threshold   = 5
#   health_check_unhealthy_threshold = 2
#   health_check_interval  = 30
#   health_check_timeout   = 5

# # listener settings
#   listener_protocol      = "HTTP"
#   target_port            = 80
#   listener_port          = 80
#   health_check_path      = "/health"
#   health_check_matcher   = "200-399"

#   tags = {
#     Project = "CBG"
#     Owner   = "CloudTeam"
#   }
# }

# CloudFront distribution for app and api (uses ALB as origin and S3 logging bucket)
# module "cloudfront" {
#   source = "../../../modules/cloudfront"

#   # Region / DNS
#   region            = "us-east-1"
#   hosted_zone_name  = "company-domain-name.com"
#   app_domain_primary   = "app.company-domain-name.com"
#   app_domain_secondary = "api.company-domain-name.com"
#   domain_name          = module.alb.alb_dns_name
#   zone_id              = module.hosted_zones.hosted_zones_id

  
#   # Logging / buckets
#   log_bucket_name   = module.s3.log_bucket_name
#   enable_cf_logging = true
#   logging_prefix_primary   = "cloudfront/primary/"
#   logging_prefix_secondary = "cloudfront/secondary/"

#   # Distribution behavior
#   enable_ipv6               = true
#   price_class               = "PriceClass_100"
#   http_version              = "http2and3"
#   viewer_protocol_policy    = "redirect-to-https"
#   minimum_protocol_version  = "TLSv1.2_2021"
#   wait_for_deployment       = true

#   # Optional: ACM cert ARN (leave empty if not using custom cert)
#   # acm_certificate_arn = ""
# }




# module "waf" {
#   source = "../../../modules/waf"

#   resource_prefix = "CBG-Dev"
#   environment     = "dev"
#   scope           = "REGIONAL"

#   associated_arns = [
#     module.alb.alb_arn,
#     module.cloudfront.primary_cf_domain,
#   ]

#   tags = {
#     Project = "CBG"
#   }
# }

# module "hosted_zones" {
#   source = "../../../modules/hosted_zones"
# domain_name = "company-domain-name.com"
# }