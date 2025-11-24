output "vpce_ids" {
  description = "Map of created Interface VPC Endpoint IDs"
  value       = { for k, v in aws_vpc_endpoint.interface_endpoints : k => v.id }
}

output "s3_vpce_id" {
  description = "ID of the S3 Gateway Endpoint"
  value       = aws_vpc_endpoint.s3.id
}

output "vpce_security_group_id" {
  description = "Security group used for VPC endpoints"
  value       = aws_security_group.vpce_sg.id
}