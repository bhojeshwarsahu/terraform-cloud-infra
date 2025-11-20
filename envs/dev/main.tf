module "vpc" {
  source           = "../../modules/vpc"
  vpc_cidr         = var.vpc_cidr
  vpc_name         = var.vpc_name
  environment      = var.environment
  instance_tenancy = var.instance_tenancy
  prevent_destroy  = var.prevent_destroy
  tags             = var.tags
}
module "subnets" {
  source      = "../../modules/subnet"
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
  tags        = var.tags
  subnets     = var.subnets
}
module "igw" {
  source      = "../../modules/igw"
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
  tags        = merge(var.tags, { Component = "networking", Role = "igw" })
}
locals {
  public_subnet_ids = { for k, id in module.subnets.subnet_ids : k => id if startswith(k, "public") }
  private_subnet_ids = { for k, id in module.subnets.subnet_ids : k => id if startswith(k, "private") }
}
module "nat" {
  source            = "../../modules/nat"
  public_subnet_ids = local.public_subnet_ids
  environment       = var.environment
  create_per_az     = true
  tags              = var.tags
}
module "routes" {
  source = "../../modules/route"

  vpc_id      = module.vpc.vpc_id
  environment = var.environment
  subnet_ids  = module.subnets.subnet_ids
  tags        = var.tags

  route_tables = {
    public = {
      subnets = keys(local.public_subnet_ids)
      routes = [
        {
          destination = "0.0.0.0/0"
          target_type = "igw"
          target_id   = module.igw.igw_id
        }
      ]
    }
    private = {
      subnets = keys(local.private_subnet_ids)
      routes = [
        {
          destination = "0.0.0.0/0"
          target_type = "nat"
          target_id   = lookup(module.nat.nat_gateway_ids, "public_1", lookup(module.nat.nat_gateway_ids, "single", null))
        }
      ]
    }
  }
}