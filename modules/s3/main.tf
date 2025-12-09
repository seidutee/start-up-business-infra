# Create the Logging Bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = var.log_bucket_name

  tags = {
    Name        = "${var.ResourcePrefix}-s3-log-bucket"

  }
}

# Create the Primary S3 Bucket
resource "aws_s3_bucket" "operations_bucket" {
  bucket = var.operations_bucket_name

  tags = {
    Name        = "${var.ResourcePrefix}-s3-bucket"

  }
}

# Enable Versioning on the Primary Bucket
resource "aws_s3_bucket_versioning" "operations_versioning" {
  bucket = aws_s3_bucket.operations_bucket.id
  versioning_configuration {
    status = var.operations_versioning_status
  }
}

# Set up S3 Replication from Operations Bucket to Replication Destination Bucket
resource "aws_s3_bucket_replication_configuration" "replication_config" {
  role   = var.replication_role_arn
  bucket = aws_s3_bucket.operations_bucket.id

  rule {
    id     = "ReplicateAllObjects"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.replication_destination_bucket.arn
      storage_class = "STANDARD"
    }

    filter {
      prefix = ""  # replicate all objects
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.operations_versioning,
    aws_s3_bucket_versioning.versioning_replication_destination
  ]
}


# Create Replication Destination Bucket
resource "aws_s3_bucket" "replication_destination_bucket" {
  bucket = var.replication_destination_bucket_name

  tags = {
    Name        = "${var.ResourcePrefix}-s3-replication-destination"
  }
}

resource "aws_s3_bucket_versioning" "versioning_replication_destination" {
  bucket = aws_s3_bucket.replication_destination_bucket.id
  versioning_configuration {
    status = var.replication_versioning_status
  }
}

resource "aws_s3_bucket_logging" "operations_bucket_logging" {
  bucket        = aws_s3_bucket.operations_bucket.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = var.logging_prefix

  depends_on = [aws_s3_bucket.log_bucket]
}


# Bucket Policies
data "aws_caller_identity" "current" {}
 
resource "aws_s3_bucket_policy" "config_and_vpc_logs_policy" {
  bucket = var.log_bucket_name
 
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # --- AWS Config permissions ---
      {
        Sid: "AWSConfigBucketPermissionsCheck",
        Effect: "Allow",
        Principal: { Service: "config.amazonaws.com" },
        Action: "s3:GetBucketAcl",
        Resource: "arn:aws:s3:::${var.log_bucket_name}"
      },
      {
        Sid: "AWSConfigBucketDelivery",
        Effect: "Allow",
        Principal: { Service: "config.amazonaws.com" },
        Action: [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ],
        Resource: "arn:aws:s3:::${var.log_bucket_name}/config-logs/*",
        Condition: {
          StringEquals: {
            "aws:SourceAccount": data.aws_caller_identity.current.account_id
          }
        }
      },
 
      # --- VPC Flow Logs permissions ---
      {
        Sid: "VPCFlowLogsBucketPermissionsCheck",
        Effect: "Allow",
        Principal: { Service: "delivery.logs.amazonaws.com" },
        Action: "s3:GetBucketAcl",
        Resource: "arn:aws:s3:::${var.log_bucket_name}"
      },
      {
        Sid: "VPCFlowLogsBucketDelivery",
        Effect: "Allow",
        Principal: { Service: "delivery.logs.amazonaws.com" },
        Action: "s3:PutObject",
        Resource: "arn:aws:s3:::${var.log_bucket_name}/vpc-flow-logs/*",
        Condition: {
          StringEquals: {
            "aws:SourceAccount": data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "replication_destination_policy" {
  bucket = aws_s3_bucket.replication_destination_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid: "AllowReplicationFromSourceBucket",
        Effect: "Allow",
        Principal = {
          AWS: var.replication_role_arn
        },
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        Resource = "${aws_s3_bucket.replication_destination_bucket.arn}/*"
      }
    ]
  })
}

 
 