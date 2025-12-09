# resource "aws_instance" "bastion" {
#   ami           = var.ami_id
#   instance_type = var.instance_type
#   subnet_id = var.public_subnet_ids[0]


  
#   tags = {
#     Name = "${var.ResourcePrefix}-PublicServer"
#   }

#   vpc_security_group_ids = [var.bastion_sg_id]
#   key_name               = var.key_pair_name

#   user_data = var.bastion_user_data

#   iam_instance_profile = var.iam_instance_profile

#   root_block_device {
#     volume_size = var.volume_size
#     volume_type = var.volume_type
#   }
# }



# module "ec2" {
#   source = "../../modules/ec2"

#   ResourcePrefix         = "CBG-Dev"
#   ami_id                 = "ami-00a929b66ed6e0de6" # Replace with a valid AMI ID
#   instance_type          = "t2.micro"
   
#   public_subnet_ids  = module.vpc.public_subnet_ids

#   bastion_sg_id = module.security.public_sg_id

#   key_pair_name           = "safoa" # Replace with your key pair name
#   iam_instance_profile =  module.iam.rbac_instance_profile # Replace with your IAM instance profile

#   volume_size        = 8 # Size in GB
#   volume_type        = "gp3"
#   bastion_user_data          = file("../../scripts/bootstrap.sh") 

# }

