variable "public_subnet_ids" {
  description = <<EOT
Map of public subnet keys -> subnet-id where NAT(s) can be placed.

Example:
{
  public_1 = "subnet-aaa"
  public_2 = "subnet-bbb"
}
EOT
  type = map(string)

  validation {
    condition     = length(var.public_subnet_ids) > 0
    error_message = "public_subnet_ids must contain at least one public subnet id."
  }
}

variable "environment" {
  description = "Environment name (e.g. dev, qa, prod)"
  type        = string
}

variable "create_per_az" {
  description = "If true create a NAT gateway for every public subnet provided. If false create a single NAT in the first provided public subnet."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to EIP and NAT resources"
  type        = map(string)
  default     = {}
}
