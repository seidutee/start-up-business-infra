module "kms" {
  source = "terraform-aws-modules/kms/aws"

  description         = "External key example"
  key_material_base64 = "Wblj06fduthWggmsT0cLVoIMOkeLbc2kVfMud77i/JY="
  valid_to            = "2085-04-12T23:20:50.52Z"

  # Policy
  key_owners         = ["arn:aws:iam::012345678901:role/owner"]
  key_administrators = ["arn:aws:iam::012345678901:role/admin"]
  key_users          = ["arn:aws:iam::012345678901:role/user"]
  key_service_users  = ["arn:aws:iam::012345678901:role/ec2-role"]

  # Aliases
  aliases                 = ["mycompany/external"]
  aliases_use_name_prefix = true

  # Grants
  grants = {
    lambda = {
      grantee_principal = "arn:aws:iam::012345678901:role/lambda-function"
      operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
      constraints = {
        encryption_context_equals = {
          Department = "Finance"
        }
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}