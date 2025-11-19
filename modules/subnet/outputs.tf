output "subnet_ids" {
  description = "The IDs of the subnets"
  value       = { for k, v in aws_subnet.this : k => v.id }
}