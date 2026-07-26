############################################################
# ebs-csi.tf
#
# Creates:
# - IAM Policy Lookup
# - IAM Trust Policy for IRSA
# - IAM Role for EBS CSI Driver
# - Policy Attachment
# - Amazon EKS Managed Add-on
############################################################

############################################################
# AWS Managed Policy
############################################################

data "aws_iam_policy" "ebs_csi" {

  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"

}

############################################################
# IAM Trust Policy
############################################################

data "aws_iam_policy_document" "ebs_csi_assume_role" {

  statement {

    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {

      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.eks.arn
      ]

    }

    condition {

      test = "StringEquals"

      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"

      values = [
        "system:serviceaccount:kube-system:ebs-csi-controller-sa"
      ]

    }

    condition {

      test = "StringEquals"

      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:aud"

      values = [
        "sts.amazonaws.com"
      ]

    }

  }

}

############################################################
# IAM Role
############################################################

resource "aws_iam_role" "ebs_csi" {

  name = "${var.cluster_name}-ebs-csi-role"

  assume_role_policy = data.aws_iam_policy_document.ebs_csi_assume_role.json

  tags = merge(

    local.common_tags,

    var.additional_tags,

    {
      Name = "${var.cluster_name}-ebs-csi-role"
    }

  )

}

############################################################
# Attach AWS Managed Policy
############################################################

resource "aws_iam_role_policy_attachment" "ebs_csi" {

  role = aws_iam_role.ebs_csi.name

  policy_arn = data.aws_iam_policy.ebs_csi.arn

}

############################################################
# Install Amazon EBS CSI Driver
############################################################

resource "aws_eks_addon" "ebs_csi" {

  cluster_name = aws_eks_cluster.eks.name

  addon_name = "aws-ebs-csi-driver"

  addon_version = null

  service_account_role_arn = aws_iam_role.ebs_csi.arn

  resolve_conflicts_on_create = "OVERWRITE"

  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [

    aws_eks_node_group.workers,

    aws_iam_role_policy_attachment.ebs_csi

  ]

}