output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "igw_arn" {
  description = "ARN of the Internet Gateway (useful in IAM/policies or logging)"
  value       = aws_internet_gateway.this.arn
}
