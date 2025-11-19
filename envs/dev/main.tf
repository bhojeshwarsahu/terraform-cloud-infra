module "vpc" {
  source           = "../../modules/vpc"
  vpc_cidr         = var.vpc_cidr
  vpc_name         = var.vpc_name
  environment      = var.environment
  instance_tenancy = var.instance_tenancy
  prevent_destroy  = var.prevent_destroy
  tags             = var.tags
}
module "subnet" {
  source      = "../../modules/subnet"
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
  tags        = var.tags
  subnets     = var.subnets
}
