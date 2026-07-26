############################################################
# IAM MODULE OUTPUTS
#
# These outputs are consumed by the EKS module.
############################################################

############################################################
# EKS Cluster IAM Role ARN
############################################################

output "eks_cluster_role_arn" {

  description = "IAM Role ARN used by the Amazon EKS Control Plane"

  value = aws_iam_role.eks_cluster_role.arn

}

############################################################
# EKS Cluster IAM Role Name
############################################################

output "eks_cluster_role_name" {

  description = "IAM Role Name for Amazon EKS Control Plane"

  value = aws_iam_role.eks_cluster_role.name

}

############################################################
# Worker Node IAM Role ARN
############################################################

output "node_group_role_arn" {

  description = "IAM Role ARN used by EKS Managed Node Group"

  value = aws_iam_role.node_group_role.arn

}

############################################################
# Worker Node IAM Role Name
############################################################

output "node_group_role_name" {

  description = "IAM Role Name used by EKS Worker Nodes"

  value = aws_iam_role.node_group_role.name

}

############################################################
# Worker Node IAM Role ID
############################################################

output "node_group_role_id" {

  description = "IAM Role ID"

  value = aws_iam_role.node_group_role.id

}

############################################################
# External Secrets Role ARN
############################################################

output "external_secrets_role_arn" {

  value = aws_iam_role.external_secrets_role.arn

}