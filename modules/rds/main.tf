#############################
# RDS Master (Primary)
#############################

resource "aws_db_instance" "rds_master" {
  identifier              = "${var.resourceprefix}-rds-master"
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  username                = var.db_username
  password                = var.db_password
  db_name                 = var.db_name

  # Attach to private subnet group (best practice)
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name

  vpc_security_group_ids  = [var.db_sg_id]
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot

  # Optional encryption
  storage_encrypted       = true

  tags = {
    Name = "${var.resourceprefix}-rds-master"
  }
}


#############################
# RDS Read Replica
#############################

resource "aws_db_instance" "rds_replica" {
  identifier              = "${var.resourceprefix}-rds-replica"
  replicate_source_db     = aws_db_instance.rds_master.arn
  instance_class          = var.replica_instance_class
  publicly_accessible     = false
  auto_minor_version_upgrade = true

  # Attach to same subnet group and SG
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [var.db_sg_id]

  tags = {
    Name = "${var.resourceprefix}-rds-replica"
  }

  depends_on = [aws_db_instance.rds_master]
}


#############################
# DB Subnet Group
#############################

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.resourceprefix}-rds-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.resourceprefix}-rds-subnet-group"
  }
}



#############################
# ElastiCache Memcached Cluster
#############################

resource "aws_elasticache_subnet_group" "cache_subnets" {
  name       = "cache-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_elasticache_cluster" "memcached_cluster" {
  cluster_id           = "app-memcached"
  engine               = "memcached"
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  port                 = var.cache_port
  subnet_group_name    = aws_elasticache_subnet_group.cache_subnets.name
  security_group_ids   = var.memcached_sg_ids
  tags = {
    Name = "app-memcached-cluster"
  }
}
  
