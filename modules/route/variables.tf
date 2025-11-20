variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "environment" {
  description = "Environment (dev/stage/prod)"
  type        = string
}

variable "route_tables" {
  description = <<EOT
Map defining route tables.

Example:
{
  public = {
    subnets = ["public_1", "public_2"]
    routes = [
      {
        destination = "0.0.0.0/0"
        target_type = "igw"
        target_id   = "igw-xxxx"
      }
    ]
  }

  private = {
    subnets = ["private_1", "private_2"]
    routes = [
      {
        destination = "0.0.0.0/0"
        target_type = "nat"
        target_id   = "nat-gw-xxxx"
      }
    ]
  }
}
EOT

  type = map(object({
    subnets = list(string)

    routes = list(object({
      destination = string
      target_type = string   # "igw" or "nat"
      target_id   = string
    }))
  }))
}

variable "subnet_ids" {
  description = "Map of subnet keys -> subnet IDs (from subnet module)"
  type        = map(string)
}

variable "tags" {
  description = "Tags to apply to all route tables"
  type        = map(string)
  default     = {}
}
