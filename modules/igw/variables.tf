variable "vpc_id" {
  description = "ID of the VPC to attach the Internet Gateway to"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/stage/prod)"
  type        = string
}

variable "name" {
  description = "Optional name tag for the IGW. If empty, module will create a default name."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Additional tags to apply to the IGW"
  type        = map(string)
  default     = {}
}
