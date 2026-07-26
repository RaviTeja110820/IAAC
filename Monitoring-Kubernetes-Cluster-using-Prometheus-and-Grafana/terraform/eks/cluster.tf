############################################################
# cluster.tf
#
# Creates:
# - CloudWatch Log Group
# - Amazon EKS Cluster
############################################################

############################################################
# CloudWatch Log Group
############################################################

resource "aws_cloudwatch_log_group" "eks" {

  # CloudWatch Log Group Name
  name = "/aws/eks/${var.cluster_name}/cluster"

  # Log Retention Period
  retention_in_days = var.log_retention_days

  # Resource Tags
  tags = merge(

    local.common_tags,

    var.additional_tags,

    {

      Name = "${var.cluster_name}-logs"

    }

  )

}

############################################################
# Amazon EKS Cluster
############################################################

resource "aws_eks_cluster" "eks" {

  ##########################################################
  # Cluster Name
  ##########################################################

  name = var.cluster_name

  ##########################################################
  # Kubernetes Version
  ##########################################################

  version = var.kubernetes_version

  ##########################################################
  # IAM Role
  ##########################################################

  role_arn = var.eks_cluster_role_arn

  ##########################################################
  # VPC Configuration
  ##########################################################

  vpc_config {

    subnet_ids = [

      var.private_subnet_1_id,

      var.private_subnet_2_id,

      var.public_subnet_1_id,

      var.public_subnet_2_id

    ]

    # Enable Private API Endpoint
    endpoint_private_access = var.endpoint_private_access

    # Enable Public API Endpoint
    endpoint_public_access = var.endpoint_public_access

    # Restrict API Server Access
    public_access_cidrs = var.public_access_cidrs

    # Cluster Security Group
    security_group_ids = [

      aws_security_group.cluster.id

    ]

  }

  ##########################################################
  # Enable Control Plane Logs
  ##########################################################

  enabled_cluster_log_types = var.cluster_log_types

  ##########################################################
  # Resource Tags
  ##########################################################

  tags = merge(

    local.common_tags,

    var.additional_tags,

    {

      Name = var.cluster_name

    }

  )

  ##########################################################
  # Terraform Timeouts
  ##########################################################

  timeouts {

    create = "30m"

    update = "60m"

    delete = "30m"

  }

  ##########################################################
  # Lifecycle
  ##########################################################

  lifecycle {

    ignore_changes = [

      tags

    ]

  }

  ##########################################################
  # Dependencies
  ##########################################################

  depends_on = [

    aws_cloudwatch_log_group.eks

  ]

}