 Reasons for using seperate bucket for logging and operations

Issue	Explanation
Log Explosion Risk	Logs are written into the bucket continuously. If the logs are stored in the same bucket they are logging, you can create a feedback loop — logging the logs about logs! It can cause huge storage bloat very fast.
Data Management Complexity	Your application data and your log data will be mixed. It becomes harder to manage lifecycle policies, expiration, backup, replication, etc.
Security & Compliance	Logs usually have different retention policies and stricter immutability/compliance needs (e.g., for auditing). Keeping them separate makes compliance audits easier.
Performance Impact	In extreme cases (very active buckets), having lots of logs in the same bucket can impact list operations and indexing.
Recovery Simplicity	If something goes wrong (accidental deletion, replication issues), it’s much easier to recover production data if logs are isolated.
✅ Best Practice
Create a separate logging bucket dedicated to receiving logs.

Enable server-side encryption on the logging bucket.

Apply strict policies (e.g., deny delete, versioning enabled) to protect logs.

Set lifecycle rules to archive or delete old logs automatically (to control cost).

Enable Object Locking if you have compliance requirements (e.g., financial, health sectors).

# main.tf

# ======= LOGGING BUCKET =======
resource "aws_s3_bucket" "log_bucket" {
  bucket = var.log_bucket_name
  acl    = var.log_bucket_acl

  tags = merge(
    {
      Name        = "${var.ResourcePrefix}-s3-log-bucket"
      Environment = var.environment
    },
    var.additional_tags
  )

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "log-expiration-rule"
    enabled = true

    expiration {
      days = 90
    }
  }

  bucket_ownership_controls {
    rule {
      object_ownership = "BucketOwnerEnforced"
    }
  }

  public_access_block_configuration {
    block_public_acls       = var.block_public_acls
    block_public_policy     = var.block_public_policy
    ignore_public_acls      = var.ignore_public_acls
    restrict_public_buckets = var.restrict_public_buckets
  }

  policy = var.log_bucket_policy != "" ? var.log_bucket_policy : null
}

# ======= REPLICATION DESTINATION BUCKET =======
resource "aws_s3_bucket" "replication_destination" {
  bucket = var.replication_destination_bucket
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = merge(
    {
      Name        = "${var.ResourcePrefix}-replication-destination"
      Environment = var.environment
    },
    var.additional_tags
  )

  public_access_block_configuration {
    block_public_acls       = var.block_public_acls
    block_public_policy     = var.block_public_policy
    ignore_public_acls      = var.ignore_public_acls
    restrict_public_buckets = var.restrict_public_buckets
  }
}

# ======= IAM ROLE FOR REPLICATION =======
resource "aws_iam_role" "replication_role" {
  name = "s3-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "replication_role_policy" {
  name = "s3-replication-policy"
  role = aws_iam_role.replication_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:ReplicateObject",
          "s3:ReplicateDelete"
        ]
        Resource = "${aws_s3_bucket.s3_bucket.arn}/*"
      },
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = aws_s3_bucket.s3_bucket.arn
      },
      {
        Effect   = "Allow"
        Action   = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete"
        ]
        Resource = "${aws_s3_bucket.replication_destination.arn}/*"
      }
    ]
  })
}

# ======= MAIN S3 BUCKET (DATA) =======
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name
  acl    = var.s3_bucket_acl

  tags = merge(
    {
      Name        = "${var.ResourcePrefix}-s3-bucket"
      Environment = var.environment
    },
    var.additional_tags
  )

  versioning {
    enabled = var.versioning_enabled
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = var.logging_prefix
  }

  lifecycle_rule {
    id      = var.lifecycle_rule_id
    enabled = var.lifecycle_rule_enabled

    noncurrent_version_expiration {
      days = var.noncurrent_version_expiration_days
    }

    expiration {
      days = var.expiration_days
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm
      }
    }
  }

  public_access_block_configuration {
    block_public_acls       = var.block_public_acls
    block_public_policy     = var.block_public_policy
    ignore_public_acls      = var.ignore_public_acls
    restrict_public_buckets = var.restrict_public_buckets
  }

  policy = var.s3_bucket_policy != "" ? var.s3_bucket_policy : null
}

# ======= REPLICATION CONFIGURATION =======
resource "aws_s3_bucket_replication_configuration" "replication" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  role   = aws_iam_role.replication_role.arn

  rules {
    id     = "replication-rule"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.replication_destination.arn
      storage_class = var.replication_storage_class
    }
  }
}

# variables.tf
variable "s3_bucket_name" {}
variable "s3_bucket_acl" {}
variable "log_bucket_name" {}
variable "log_bucket_acl" {}
variable "replication_destination_bucket" {}
variable "versioning_enabled" { default = true }
variable "lifecycle_rule_id" {}
variable "lifecycle_rule_enabled" {}
variable "noncurrent_version_expiration_days" {}
variable "expiration_days" {}
variable "sse_algorithm" { default = "AES256" }
variable "block_public_acls" { default = true }
variable "block_public_policy" { default = true }
variable "ignore_public_acls" { default = true }
variable "restrict_public_buckets" { default = true }
variable "s3_bucket_policy" { default = "" }
variable "log_bucket_policy" { default = "" }
variable "logging_prefix" { default = "logs/" }
variable "replication_storage_class" { default = "STANDARD" }
variable "environment" {}
variable "ResourcePrefix" {}
variable "additional_tags" { default = {} }
