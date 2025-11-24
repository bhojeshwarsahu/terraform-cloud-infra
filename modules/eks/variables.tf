variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "tf-eks-cluster"
}

variable "environment" {
  description = "Environment name (dev/prod/qa)"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "VPC id where EKS will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for worker nodes and pods"
  type        = list(string)
}

variable "node_groups" {
  description = "Map of managed node groups to create."
  type = map(object({
    instance_types        = list(string)
    desired_capacity      = number
    min_capacity          = number
    max_capacity          = number
    labels                = optional(map(string), {})
    tags                  = optional(map(string), {})
    key_name              = optional(string, "")
    additional_iam_policies = optional(list(string), [])
  }))
  default = {}
}


variable "create_fargate_profile" {
  description = "Create a Fargate profile for running serverless pods"
  type        = bool
  default     = false
}

variable "fargate_selectors" {
  description = "List of selectors for the fargate profile"
  type        = list(object({ namespace = string, labels = optional(map(string), {}) }))
  default     = []
}

variable "enable_irsa" {
  description = "Enable IAM Roles for Service Accounts (IRSA)"
  type        = bool
  default     = true
}

variable "cluster_addons" {
  description = "Kubernetes addons to enable via the module (kube-proxy, coredns, vpc-cni...)"
  type        = list(string)
  default     = ["vpc-cni", "kube-proxy", "coredns"]
}

variable "endpoint_private_access" {
  description = "Enable private endpoint access to EKS control plane"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
  description = "Enable public access to EKS control plane (set false for private-only)"
  type        = bool
  default     = false
}

variable "public_access_cidrs" {
  description = "If public access enabled, restrict to these CIDRs"
  type        = list(string)
  default     = []
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "tags" {
  description = "Tags to apply to AWS resources"
  type        = map(string)
  default     = {}
}
