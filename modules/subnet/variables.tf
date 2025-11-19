variable "vpc_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "subnets" {
  type = map(object({
    name = string
    cidr = string
    az   = string
  }))
  description = "Map of subnets to create"
}
