# ---------------------------------------
# AWS EFS File System
# ---------------------------------------
resource "aws_efs_file_system" "app_efs" {
  creation_token   = "${var.resource_prefix}-efs"
  encrypted        = var.efs_encrypted
  performance_mode = var.efs_performance_mode
  throughput_mode  = var.efs_throughput_mode

  tags = {
    Name        = "${var.resource_prefix}-efs"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ---------------------------------------
# EFS Lifecycle Policy
# ---------------------------------------
resource "aws_efs_file_system" "efs_lifecycle_policy" {
  count = var.enable_efs_lifecycle_policy ? 1 : 0

    lifecycle_policy {
    transition_to_ia = var.efs_transition_to_ia
  }
}

# ---------------------------------------
# EFS Backup Policy
# ---------------------------------------
resource "aws_efs_backup_policy" "efs_backup_policy" {
  count = var.enable_efs_backup_policy ? 1 : 0

  file_system_id = aws_efs_file_system.app_efs.id
  backup_policy {
    status = var.efs_backup_status
  }
}


# ---------------------------------------
# EFS Mount Targets — one per private subnet (AZ)
# ---------------------------------------
resource "aws_efs_mount_target" "mount_targets" {
  for_each = { for idx, subnet_id in var.private_subnet_map : idx => subnet_id }

  file_system_id  = aws_efs_file_system.app_efs.id
  subnet_id       = each.value
  security_groups = [var.efs_sg_id]

  depends_on = [aws_efs_file_system.app_efs]
}


