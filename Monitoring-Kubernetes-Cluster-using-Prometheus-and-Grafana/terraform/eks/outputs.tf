############################################################
# outputs.tf
#
# Outputs from Amazon EKS Module
############################################################

############################################################
# Cluster Name
############################################################

output "cluster_name" {

  description = "Amazon EKS Cluster Name"

  value = aws_eks_cluster.eks.name

}

############################################################
# Cluster ARN
############################################################

output "cluster_arn" {

  description = "Amazon EKS Cluster ARN"

  value = aws_eks_cluster.eks.arn

}

############################################################
# Cluster Endpoint
############################################################

output "cluster_endpoint" {

  description = "Amazon EKS API Endpoint"

  value = aws_eks_cluster.eks.endpoint

}

############################################################
# Kubernetes Version
############################################################

output "cluster_version" {

  description = "Kubernetes Version"

  value = aws_eks_cluster.eks.version

}

############################################################
# Cluster Certificate Authority
############################################################

output "cluster_certificate_authority_data" {

  description = "Cluster Certificate"

  value = aws_eks_cluster.eks.certificate_authority[0].data

}

############################################################
# OIDC Issuer URL
############################################################

output "cluster_oidc_issuer_url" {

  description = "OIDC Issuer URL"

  value = aws_eks_cluster.eks.identity[0].oidc[0].issuer

}

############################################################
# Cluster Security Group
############################################################

output "cluster_security_group_id" {

  description = "Cluster Security Group"

  value = aws_security_group.cluster.id

}

############################################################
# Worker Security Group
############################################################

output "worker_security_group_id" {

  description = "Worker Node Security Group"

  value = aws_security_group.nodes.id

}

############################################################
# Managed Node Group Name
############################################################

output "node_group_name" {

  description = "Managed Node Group Name"

  value = aws_eks_node_group.workers.node_group_name

}

############################################################
# Managed Node Group ARN
############################################################

output "node_group_arn" {

  description = "Managed Node Group ARN"

  value = aws_eks_node_group.workers.arn

}

############################################################
# Node IAM Role
############################################################

output "node_role_arn" {

  description = "Worker Node IAM Role"

  value = var.node_group_role_arn

}

############################################################
# Cluster IAM Role
############################################################

output "cluster_role_arn" {

  description = "Cluster IAM Role"

  value = var.eks_cluster_role_arn

}

############################################################
# OIDC Provider ARN
############################################################

output "oidc_provider_arn" {

  value = aws_iam_openid_connect_provider.eks.arn

}

############################################################
# OIDC Provider URL
############################################################

output "oidc_provider_url" {

  value = aws_eks_cluster.eks.identity[0].oidc[0].issuer

}