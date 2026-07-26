############################################################
# SECURITY GROUPS
#
# Creates
#
# - Cluster Security Group
# - Worker Node Security Group
# - Security Group Rules
############################################################

############################################################
# Cluster Security Group
############################################################

resource "aws_security_group" "cluster" {

  name = "${var.cluster_name}-cluster-sg"

  description = "Amazon EKS Cluster Security Group"

  vpc_id = var.vpc_id

  tags = merge(

    local.common_tags,

    {

      Name = "${var.cluster_name}-cluster-sg"

    }

  )

}

############################################################
# Worker Node Security Group
############################################################

resource "aws_security_group" "nodes" {

  name = "${var.cluster_name}-nodes-sg"

  description = "Amazon EKS Worker Node Security Group"

  vpc_id = var.vpc_id

  tags = merge(

    local.common_tags,

    {

      Name = "${var.cluster_name}-nodes-sg"

    }

  )

}

############################################################
# Worker Nodes -> Worker Nodes
############################################################

resource "aws_security_group_rule" "node_to_node" {

  type = "ingress"

  from_port = 0

  to_port = 65535

  protocol = "-1"

  security_group_id = aws_security_group.nodes.id

  self = true

}

############################################################
# Cluster -> Worker Nodes
############################################################

resource "aws_security_group_rule" "cluster_to_nodes" {

  type = "egress"

  from_port = 0

  to_port = 0

  protocol = "-1"

  security_group_id = aws_security_group.cluster.id

  source_security_group_id = aws_security_group.nodes.id

}

############################################################
# Worker Nodes -> Cluster
############################################################

resource "aws_security_group_rule" "nodes_to_cluster" {

  type = "ingress"

  from_port = 443

  to_port = 443

  protocol = "tcp"

  security_group_id = aws_security_group.cluster.id

  source_security_group_id = aws_security_group.nodes.id

}

############################################################
# Worker Nodes Internet Access
############################################################

resource "aws_security_group_rule" "nodes_outbound" {

  type = "egress"

  from_port = 0

  to_port = 0

  protocol = "-1"

  security_group_id = aws_security_group.nodes.id

  cidr_blocks = [

    "0.0.0.0/0"

  ]

}