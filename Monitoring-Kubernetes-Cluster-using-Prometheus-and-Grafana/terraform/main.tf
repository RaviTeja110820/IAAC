############################################################
# main.tf
#
# Calls Terraform modules.
# Modules will be created in the next parts.
############################################################
############################################################
# Root Module
#
# Calls all child Terraform modules
############################################################

module "vpc" {

  source = "./vpc"

  project_name = var.project_name
  environment  = var.environment

  cluster_name = var.cluster_name

  vpc_cidr = var.vpc_cidr

  public_subnet_1  = var.public_subnet_1
  public_subnet_2  = var.public_subnet_2

  private_subnet_1 = var.private_subnet_1
  private_subnet_2 = var.private_subnet_2

  az1 = var.az1
  az2 = var.az2

}

############################################################
# IAM Module
############################################################

module "iam" {

  source = "./iam"

  project_name = var.project_name

  environment = var.environment

  cluster_name = var.cluster_name

  aws_region = var.aws_region

  aws_account_id = var.aws_account_id
  
  oidc_provider_arn = module.eks.oidc_provider_arn

  oidc_provider_url = module.eks.oidc_provider_url

}

############################################################
# Amazon EKS Module
############################################################

module "eks" {

  source = "./eks"

  project_name = var.project_name

  environment = var.environment

  aws_region = var.aws_region

  cluster_name = var.cluster_name

  kubernetes_version = var.kubernetes_version

  vpc_id = module.vpc.vpc_id

  public_subnet_1_id = module.vpc.public_subnet_1_id

  public_subnet_2_id = module.vpc.public_subnet_2_id

  private_subnet_1_id = module.vpc.private_subnet_1_id

  private_subnet_2_id = module.vpc.private_subnet_2_id

  eks_cluster_role_arn = module.iam.eks_cluster_role_arn

  node_group_role_arn = module.iam.node_group_role_arn

  instance_types = var.instance_types

  desired_size = var.desired_size

  min_size = var.min_size

  max_size = var.max_size

  disk_size = var.disk_size

  endpoint_public_access = var.endpoint_public_access

  endpoint_private_access = var.endpoint_private_access

  capacity_type = var.capacity_type

  node_group_name = var.node_group_name

  ami_type = var.ami_type

  public_access_cidrs = var.public_access_cidrs

  enable_irsa = var.enable_irsa

  node_labels = var.node_labels

  additional_tags = var.additional_tags

}



############################################################
# CloudWatch Module
############################################################

module "cloudwatch" {

  source = "./cloudwatch"

  project_name = var.project_name

  environment = var.environment

  cluster_name = var.cluster_name

  alarm_email = var.alarm_email

  cpu_threshold = var.cpu_threshold

  memory_threshold = var.memory_threshold

  aws_region = var.aws_region

  node_group_name = var.node_group_name

  additional_tags = var.additional_tags

}