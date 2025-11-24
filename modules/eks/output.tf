output "cluster_id" {
  value       = module.eks.cluster_id
  description = "EKS cluster ID"
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "EKS API server endpoint"
}

output "cluster_oidc_issuer" {
  # FIXED: Name is "cluster_oidc_issuer_url" in v19
  value       = module.eks.cluster_oidc_issuer_url
  description = "OIDC issuer URL (for IRSA)"
}

output "kubeconfig_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "node_group_names" {
  # FIXED: Name is "eks_managed_node_groups" in v19
  value       = keys(module.eks.eks_managed_node_groups)
  description = "Names of created node groups"
}

output "fargate_profile_names" {
  # FIXED: Name is "fargate_profiles" in v19
  value       = keys(module.eks.fargate_profiles)
  description = "Names of created Fargate profiles"
}