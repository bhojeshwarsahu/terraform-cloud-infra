# EKS module (wrapper around terraform-aws-modules/eks/aws)

## This module creates:
- EKS control plane (managed)
- Managed node groups (based on var.node_groups)
- Optional Fargate profile
- IRSA (IAM Roles for Service Accounts)
- Control plane logging and addon installation

Usage: call from envs/<env>/main.tf and pass vpc_id and private_subnet_ids.

Defaults: private control plane, IRSA enabled, managed addons (vpc-cni, kube-proxy, coredns).
