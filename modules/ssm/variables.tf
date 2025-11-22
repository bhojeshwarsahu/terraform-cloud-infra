variable "environment" {
  description = "Environment name (dev/prod/qa)"
  type        = string
}

variable "attach_cloudwatch" {
  description = "Attach CloudWatch agent policy to instance role (optional)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to IAM resources"
  type        = map(string)
  default     = {}
}
