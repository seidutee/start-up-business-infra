output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "private_subnet_map" {
  description = "Map of availability zones to private subnet IDs"
  value = {
    for key, subnet in aws_subnet.private_subnet :
    element(var.availability_zones, tonumber(key)) => subnet.id
  }
}
output "public_subnet_map" {
  description = "Map of availability zones to public subnet IDs"
  value = {
    for key, subnet in aws_subnet.public_subnet :
    element(var.availability_zones, tonumber(key)) => subnet.id
  }
}
output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for subnet in aws_subnet.private_subnet : subnet.id]
}
output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for subnet in aws_subnet.public_subnet : subnet.id]
}
