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

# Map of subnet keys (as defined in terraform.tfvars) -> subnet-id
output "subnet_ids" {
  description = "Map of subnet keys to subnet IDs"
  value       = module.subnets.subnet_ids
}

# Convenience: list of subnet IDs (unordered)
output "subnet_ids_list" {
  description = "List of subnet IDs"
  value       = values(module.subnets.subnet_ids)
}


output "igw_id" {
  value = module.igw.igw_id
}
output "igw_arn" {
  value = module.igw.igw_arn
}
output "nat_gateway_ids" {
  description = "Map of keys -> NAT Gateway IDs"
  value       = module.nat.nat_gateway_ids
}