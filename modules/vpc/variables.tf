variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC"
}

variable "vpc_name" {
  type        = string
  description = "Name tag for the VPC"
}

variable "environment" {
  type        = string
  description = "Environment (dev/stage/prod)"
  default     = "dev"
}

variable "instance_tenancy" {
  type        = string
  description = "VPC default tenancy"
  default     = "default"
  validation {
    condition     = contains(["default","dedicated"], var.instance_tenancy)
    error_message = "instance_tenancy must be 'default' or 'dedicated'"
  }
}

variable "prevent_destroy" {
  type        = bool
  description = "Whether to prevent accidental destruction"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to merge"
  default     = {}
}
