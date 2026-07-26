############################################################
# ROOT OUTPUTS
#
# Outputs from child modules
############################################################

############################################################
# Project Information
############################################################

output "project_name" {

  value = var.project_name

}

output "environment" {

  value = var.environment

}

output "aws_region" {

  value = var.aws_region

}

############################################################
# Networking
############################################################

output "vpc_id" {

  value = module.vpc.vpc_id

}

output "public_subnet_1_id" {

  value = module.vpc.public_subnet_1_id

}

output "public_subnet_2_id" {

  value = module.vpc.public_subnet_2_id

}

output "private_subnet_1_id" {

  value = module.vpc.private_subnet_1_id

}

output "private_subnet_2_id" {

  value = module.vpc.private_subnet_2_id

}

output "nat_gateway_ip" {

  value = module.vpc.nat_eip

}

############################################################
# IAM Outputs
############################################################

output "eks_cluster_role_arn" {

  value = module.iam.eks_cluster_role_arn

}

output "node_group_role_arn" {

  value = module.iam.node_group_role_arn

}

output "node_group_role_name" {

  value = module.iam.node_group_role_name

}

############################################################
# Amazon EKS Outputs
############################################################

output "cluster_name" {

  value = module.eks.cluster_name

}

output "cluster_endpoint" {

  value = module.eks.cluster_endpoint

}

output "cluster_version" {

  value = module.eks.cluster_version

}

output "cluster_oidc_issuer_url" {

  value = module.eks.cluster_oidc_issuer_url

}

output "cluster_security_group_id" {

  value = module.eks.cluster_security_group_id

}

output "worker_security_group_id" {

  value = module.eks.worker_security_group_id

}

output "node_group_name" {

  value = module.eks.node_group_name

}

############################################################
# CloudWatch Outputs
############################################################

output "cloudwatch_dashboard" {

  value = module.cloudwatch.dashboard_name

}

output "cloudwatch_sns_topic" {

  value = module.cloudwatch.sns_topic_arn

}

output "cpu_alarm" {

  value = module.cloudwatch.cpu_alarm_name

}