resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = var.instance_tenancy

  tags = merge(
    {
      Name        = var.vpc_name
      Environment = var.environment
      Owner       = "platform-team"
    },
    var.tags
  )
}