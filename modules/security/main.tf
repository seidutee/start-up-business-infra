resource "aws_security_group" "public_sg" {
  vpc_id = var.vpc_id
  tags = { Name = "${var.ResourcePrefix}-public-sg" }
 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.public_sg_source_cidr
  }
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.public_sg_source_cidr
  }
 
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.public_sg_source_cidr
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.public_sg_destination_cidr
  }
}
 
# Create Security Groups for Private subnets
 
resource "aws_security_group" "private_sg" {
  vpc_id = var.vpc_id
  tags = { Name = "${var.ResourcePrefix}-private-sg" }
 
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.private_sg_destination_cidr
  }
}
 
# Create Security Groups for ALBs
 
resource "aws_security_group" "alb_sg" {
  name        = "${var.ResourcePrefix}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id  
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.alb_sg_source_cidr_80
  }
 
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.alb_sg_source_cidr_443
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.alb_sg_destination_cidr
  }
 
  tags = {
    Name = "${var.ResourcePrefix}-alb-sg"
  }
}
 
# Create Security Groups for Web servers
 
resource "aws_security_group" "web_sg" {
  name        = "${var.ResourcePrefix}-web-sg"
  description = "Security group for Web instances"
  vpc_id      = var.vpc_id  
  
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.web_sg_destination_cidr
  }
 
  tags = {
    Name = "${var.ResourcePrefix}-web-sg"
  }
 
  depends_on = [aws_security_group.alb_sg]
}
 
# Create Security Groups for App servers
 
resource "aws_security_group" "app_sg" {
  name        = "${var.ResourcePrefix}-app-sg"
  description = "Security group for App instances"
  vpc_id      = var.vpc_id  
 
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.app_sg_destination_cidr
  }
 
  tags = {
    Name = "${var.ResourcePrefix}-app-sg"
  }
 
  depends_on = [aws_security_group.web_sg]
}
 
# Create Security Groups for DB servers
 
resource "aws_security_group" "db_sg" {
  name        = "${var.ResourcePrefix}-db-sg"
  description = "Allow inbound traffic to DB instances"
  vpc_id      = var.vpc_id  
 
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.db_sg_destination_cidr
  }
 
  tags = {
    Name = "${var.ResourcePrefix}-db-sg"
  }
 
  depends_on = [aws_security_group.app_sg]
}
 
# Create Security Groups for EFS
 
resource "aws_security_group" "efs_sg" {
  name        = "${var.ResourcePrefix}-efs-sg"
  description = var.efs_sg_description
  vpc_id      = var.vpc_id
 
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.efs_source_cidr]
  }
 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.efs_destination_cidr]
  }
}
 
# Create Security Groups for NFS Share
 
resource "aws_security_group" "nfs_sg" {
    name        = "${var.ResourcePrefix}-nfs-sg"
    description = var.nfs_sg_description
    vpc_id      = var.vpc_id
 
    ingress {
        from_port   = 2049
        to_port     = 2049
        protocol    = "tcp"
        cidr_blocks = [var.nfs_source_cidr]
    }
 
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [var.nfs_destination_cidr]
    }
}

resource "aws_security_group" "monitoring_sg" {
  name        = "${var.ResourcePrefix}-monitoring-sg"
  description = "Allow access to Prometheus and Grafana"
  vpc_id      = var.vpc_id
 
  dynamic "ingress" {
    for_each = var.monitoring_sg_ingress_rules
    content {
      description = lookup(ingress.value, "description", null)
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = lookup(ingress.value, "cidr_blocks", [])
    }
  }
 
  dynamic "egress" {
    for_each = var.monitoring_sg_egress_rules
    content {
      description = lookup(egress.value, "description", null)
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = lookup(egress.value, "cidr_blocks", [])
    }
  }
 
  tags = {
    Name = "${var.ResourcePrefix}-monitoring-sg"
  }
}
 
 # Memcached SG
resource "aws_security_group" "memcached_sg" {
  name        = "memcached-sg"
  description = "Allows Memcached access from app servers"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 11211
    to_port         = 11211
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
}
 
