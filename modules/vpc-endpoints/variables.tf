variable "vpc_id" {
  description = "VPC id to create interface endpoints in"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs to place interface endpoints into"
  type        = list(string)
}

variable "region" {
  description = "AWS region for service endpoints"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev/prod/qa)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr_blocks" {
  description = "CIDR(s) allowed to reach the VPC endpoint security group"
  type        = list(string)
  default     = []
}

# This is the new variable required for the S3 Gateway endpoint
variable "private_route_table_ids" {
  description = "List of route table IDs to associate with Gateway Endpoints (S3)"
  type        = list(string)
  default     = []
}