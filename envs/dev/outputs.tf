output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr
}

output "vpc_name" {
  description = "The name of the VPC"
  value       = module.vpc.vpc_name
}

output "subnet_ids" {
  description = "Map of subnet keys to subnet IDs"
  value       = module.subnet.subnet_ids
}

output "subnet_ids_list" {
  description = "List of subnet IDs"
  value       = values(module.subnet.subnet_ids)
}
