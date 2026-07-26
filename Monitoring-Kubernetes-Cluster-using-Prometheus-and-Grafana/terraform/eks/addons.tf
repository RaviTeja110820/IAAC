############################################################
# addons.tf
#
# Amazon EKS Managed Add-ons
#
# Creates
# - VPC CNI
# - CoreDNS
# - kube-proxy
############################################################

############################################################
# Amazon VPC CNI
############################################################

resource "aws_eks_addon" "vpc_cni" {

  cluster_name = aws_eks_cluster.eks.name

  addon_name = "vpc-cni"

  resolve_conflicts_on_create = "OVERWRITE"

  resolve_conflicts_on_update = "OVERWRITE"

  tags = merge(

    local.common_tags,

    {

      Name = "vpc-cni"

    }

  )

  depends_on = [

    aws_eks_node_group.workers

  ]

}

############################################################
# CoreDNS
############################################################

resource "aws_eks_addon" "coredns" {

  cluster_name = aws_eks_cluster.eks.name

  addon_name = "coredns"

  resolve_conflicts_on_create = "OVERWRITE"

  resolve_conflicts_on_update = "OVERWRITE"

  tags = merge(

    local.common_tags,

    {

      Name = "coredns"

    }

  )

  depends_on = [

    aws_eks_node_group.workers

  ]

}

############################################################
# kube-proxy
############################################################

resource "aws_eks_addon" "kube_proxy" {

  cluster_name = aws_eks_cluster.eks.name

  addon_name = "kube-proxy"

  resolve_conflicts_on_create = "OVERWRITE"

  resolve_conflicts_on_update = "OVERWRITE"

  tags = merge(

    local.common_tags,

    {

      Name = "kube-proxy"

    }

  )

  depends_on = [

    aws_eks_node_group.workers

  ]

}