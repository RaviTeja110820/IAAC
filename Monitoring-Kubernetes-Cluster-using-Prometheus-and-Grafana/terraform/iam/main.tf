############################################################
# IAM MODULE
#
# Creates:
# - EKS Cluster IAM Role
# - EKS Worker Node IAM Role
# - AWS Managed Policy Attachments
############################################################

############################################################
# Local Tags
############################################################

locals {

  common_tags = {

    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"

  }

}

############################################################
# EKS Cluster Assume Role Policy
############################################################

data "aws_iam_policy_document" "eks_cluster_assume_role" {

  statement {

    effect = "Allow"

    principals {

      type = "Service"

      identifiers = [
        "eks.amazonaws.com"
      ]

    }

    actions = [
      "sts:AssumeRole"
    ]

  }

}

############################################################
# EKS Cluster IAM Role
############################################################

resource "aws_iam_role" "eks_cluster_role" {

  name = "${var.project_name}-${var.environment}-eks-cluster-role"

  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json

  tags = merge(
    local.common_tags,
    {
      Name = "eks-cluster-role"
    }
  )

}

############################################################
# Attach AmazonEKSClusterPolicy
############################################################

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {

  role = aws_iam_role.eks_cluster_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

}

############################################################
# Attach AmazonEKSVPCResourceController
############################################################

resource "aws_iam_role_policy_attachment" "eks_vpc_controller" {

  role = aws_iam_role.eks_cluster_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"

}

############################################################
# Node Group Assume Role Policy
############################################################

data "aws_iam_policy_document" "node_group_assume_role" {

  statement {

    effect = "Allow"

    principals {

      type = "Service"

      identifiers = [
        "ec2.amazonaws.com"
      ]

    }

    actions = [
      "sts:AssumeRole"
    ]

  }

}

############################################################
# Node Group IAM Role
############################################################

resource "aws_iam_role" "node_group_role" {

  name = "${var.project_name}-${var.environment}-node-group-role"

  assume_role_policy = data.aws_iam_policy_document.node_group_assume_role.json

  tags = merge(
    local.common_tags,
    {
      Name = "node-group-role"
    }
  )

}

############################################################
# AmazonEKSWorkerNodePolicy
############################################################

resource "aws_iam_role_policy_attachment" "worker_node_policy" {

  role = aws_iam_role.node_group_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

}

############################################################
# AmazonEC2ContainerRegistryReadOnly
############################################################

resource "aws_iam_role_policy_attachment" "ecr_read_only" {

  role = aws_iam_role.node_group_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

}

############################################################
# AmazonEKS_CNI_Policy
############################################################

resource "aws_iam_role_policy_attachment" "cni_policy" {

  role = aws_iam_role.node_group_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

}

############################################################
# AmazonSSMManagedInstanceCore
############################################################

resource "aws_iam_role_policy_attachment" "ssm_policy" {

  role = aws_iam_role.node_group_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

}

############################################################
# CloudWatch Agent Server Policy
############################################################

resource "aws_iam_role_policy_attachment" "cloudwatch_policy" {

  role = aws_iam_role.node_group_role.name

  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"

}
