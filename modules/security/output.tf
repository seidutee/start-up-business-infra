output "public_sg_id" {
  description = "ID of the public security group"
  value       = aws_security_group.public_sg.id
}

output "private_sg_id" {
  description = "ID of the private security group"
  value       = aws_security_group.private_sg.id
}

output "db_sg_id" {
  description = "ID of the database security group"
  value       = aws_security_group.db_sg.id
  
}
output "monitoring_sg_id" {
  value = aws_security_group.monitoring_sg.id  
 
}
 
 output "nfs_sg_id" {
  value = aws_security_group.nfs_sg.id  
 
}
output "web_sg_id" {
  value = aws_security_group.web_sg.id  
 
}

output "efs_sg_id" {
  value = aws_security_group.efs_sg.id  
 
}

output "memcached_sg_ids" {
  value = aws_security_group.memcached_sg.id  
}

output "app_sg_id" {
  value = aws_security_group.app_sg.id  
 
}
output "alb_sg_id" {
  value = aws_security_group.alb_sg.id  
 
}
