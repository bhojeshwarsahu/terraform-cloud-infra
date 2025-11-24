locals {
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  )
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  # Control Plane ENIs will be placed here.
  # Since these are private subnets, your API server is not directly exposed to the internet.
  subnet_ids = var.private_subnet_ids 
  
  # API endpoint access
  cluster_endpoint_private_access      = var.endpoint_private_access
  cluster_endpoint_public_access       = var.endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.public_access_cidrs

  enable_irsa = var.enable_irsa

  cluster_addons = {
    for addon in var.cluster_addons :
    addon => {
      most_recent = true # Added to ensure you get working versions
    }
  }

  eks_managed_node_groups = {
    for ng_name, ng in var.node_groups :
    ng_name => {
      desired_size = ng.desired_capacity
      min_size     = ng.min_capacity
      max_size     = ng.max_capacity

      instance_types = ng.instance_types
      key_name       = lookup(ng, "key_name", null)

      # Ensure nodes are not reachable from internet directly
      subnet_ids = var.private_subnet_ids 

      labels = lookup(ng, "labels", {})
      
      # Correctly merges global tags with node-group specific tags
      tags = merge(
        local.common_tags,
        lookup(ng, "tags", {})
      )

      # --- CRITICAL FIX: Convert List to Map ---
      # The module expects a map { "name" = "arn" }, but variables provided a list ["arn"]
      iam_role_additional_policies = { 
        for i, policy_arn in lookup(ng, "additional_iam_policies", []) : 
        "additional-policy-${i}" => policy_arn 
      }
    }
  }

  # Fargate profile 
  fargate_profiles = var.create_fargate_profile ? {
    default = {
      subnet_ids = var.private_subnet_ids # Explicitly ensuring Fargate runs in private
      selectors = [
        for s in var.fargate_selectors : {
          namespace = s.namespace
          labels    = lookup(s, "labels", {})
        }
      ]
    }
  } : {}

  tags = local.common_tags

  # Enable logging to CloudWatch (Critical for debugging private clusters)
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}