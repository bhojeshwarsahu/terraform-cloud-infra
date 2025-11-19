module "vpc" {
  source           = "../../modules/vpc"
  vpc_cidr         = var.vpc_cidr
  vpc_name         = var.vpc_name
  environment      = var.environment
  instance_tenancy = var.instance_tenancy
  prevent_destroy  = var.prevent_destroy
  tags             = var.tags
}

# create public subnets (example map)
locals {
  azs = ["us-east-1a", "us-east-1b"]
  public_subnets = {
    for i, az in local.azs :
    "public-${i}" => {
      name                    = "${var.environment}-public-${i}"
      az                      = az
      cidr                    = cidrsubnet(module.vpc.vpc_cidr, 8, i) # adjust prefix_len
      map_public_ip_on_launch = true
    }
  }
  private_subnets = {
    for i, az in local.azs :
    "private-${i}" => {
      name = "${var.environment}-private-${i}"
      az   = az
      cidr = cidrsubnet(module.vpc.vpc_cidr, 8, i + length(local.azs))
    }
  }
}

module "public_subnets" {
  source      = "../../modules/subnet"
  vpc_id      = module.vpc.vpc_id
  subnets     = local.public_subnets
  common_tags = var.tags
}

module "private_subnets" {
  source      = "../../modules/subnet"
  vpc_id      = module.vpc.vpc_id
  subnets     = local.private_subnets
  common_tags = var.tags
}

module "igw" {
  source = "../../modules/igw"
  vpc_id = module.vpc.vpc_id
  tags   = var.tags
}

# create NAT per AZ (pass map of public subnet ids)
module "nat" {
  source            = "../../modules/nat"
  public_subnet_ids = { for k, id in module.public_subnets.subnet_map : k => id }
  tags              = var.tags
}

# route tables - pass one nat (choose nat per-az logic or pick first)
module "route" {
  source             = "../../modules/route"
  vpc_id             = module.vpc.vpc_id
  igw_id             = module.igw.igw_id
  nat_gateway_id     = values(module.nat.nat_gateway_ids)[0] # example: pick first NAT
  public_subnet_ids  = { for k, id in module.public_subnets.subnet_map : k => id }
  private_subnet_ids = { for k, id in module.private_subnets.subnet_map : k => id }
  environment        = var.environment
  tags               = var.tags
}