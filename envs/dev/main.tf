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
  public_subnet_ids  = { for k, id in module.subnets.subnet_ids : k => id if startswith(k, "public") }
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

# Upload an existing public key from local file (recommended)
# module "keypair" {
#   source          = "../../modules/keypair"
#   name            = "${var.environment}-ssh-key"
#   public_key_path = "${pathexpand("~/.ssh/id_rsa.pub")}"
#   # public_key_path = "~/.ssh/id_rsa.pub"   # or relative path to repo
#   tags            = merge(var.tags, { Component = "ssh" })
# }

module "keypair" {
  source          = "../../modules/keypair"
  name            = "${var.environment}-ssh-key"
  public_key_path = pathexpand("~/.ssh/id_rsa.pub")
  tags            = merge(var.tags, { Component = "ssh" })
}

# OR — generate a keypair (not recommended for production because of private key handling)
# module "keypair_generated" {
#   source           = "../../modules/keypair"
#   name             = "${var.environment}-auto-key"
#   generate_key     = true
#   rsa_bits         = 4096
#   save_private_key = true
#   private_key_path = "../secrets/${var.environment}_auto_key.pem" # make sure folder exists and is protected
#   tags             = merge(var.tags, { Component = "ssh" })
# }

module "ssm" {
  source            = "../../modules/ssm"
  environment       = var.environment
  attach_cloudwatch = true # optional, set false if you don't want CloudWatchAgentServerPolicy
  tags              = merge(var.tags, { Component = "ssm" })
}

module "eks" {
  source = "../../modules/eks"

  cluster_name       = "dev-eks-cluster"
  environment        = var.environment
  region             = "us-east-1"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = values({ for k, id in module.subnets.subnet_ids : k => id if startswith(k, "private") })
  
  # REMOVED unused public_subnet_ids to clean up
  
  endpoint_private_access = true
  endpoint_public_access  = false
  public_access_cidrs     = []

  node_groups = {
    default = {
      instance_types   = ["t3.medium"]
      desired_capacity = 2
      min_capacity     = 1
      max_capacity     = 3
      key_name         = null
      labels           = { role = "worker" }
      tags             = { Purpose = "eks-node" }
      additional_iam_policies = [
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
        "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
      ]
    }
  }

  enable_irsa            = true
  create_fargate_profile = false
  tags                   = merge(var.tags, { Component = "eks" })
}

module "vpc_endpoints" {
  source = "../../modules/vpc-endpoints"

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = values(local.private_subnet_ids)
  region             = "us-east-1"
  environment        = var.environment
  vpc_cidr_blocks    = [var.vpc_cidr]

  # ADDED: Pass the private route table ID so the S3 Gateway Endpoint can attach to it
  # Note: This assumes your route module outputs "route_table_ids" as a map
  private_route_table_ids = [module.routes.route_table_ids["private"]]
}