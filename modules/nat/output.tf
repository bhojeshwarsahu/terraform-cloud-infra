output "nat_gateway_ids" {
  description = "Map of keys -> NAT Gateway IDs (keys match public_subnet_ids or 'single')"
  value       = { for k, v in aws_nat_gateway.this : k => v.id }
}

output "nat_eip_allocation_ids" {
  description = "Map of keys -> EIP allocation IDs used by NAT Gateways"
  value       = { for k, v in aws_eip.nat : k => v.id }
}

output "nat_gateway_ids_list" {
  description = "List of NAT Gateway IDs (unordered)"
  value       = [for k, v in aws_nat_gateway.this : v.id]
}
