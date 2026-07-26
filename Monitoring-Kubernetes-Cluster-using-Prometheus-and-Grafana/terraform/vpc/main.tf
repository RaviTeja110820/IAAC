############################################################
# VPC MODULE
#
# This module creates:
# - VPC
# - Internet Gateway
# - Public Subnets
# - Private Subnets
# - Elastic IP
# - NAT Gateway
# - Route Tables
# - Route Table Associations
#
# This VPC is designed for Amazon EKS.
############################################################

############################################################
# Local Variables
############################################################

locals {

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

}

############################################################
# Create VPC
############################################################

resource "aws_vpc" "main" {

  cidr_block           = var.vpc_cidr

  enable_dns_support   = true

  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-vpc"
    }
  )

}

############################################################
# Internet Gateway
############################################################

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-igw"
    }
  )

}

############################################################
# Public Subnet 1
############################################################

resource "aws_subnet" "public1" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet_1

  availability_zone = var.az1

  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {

      Name = "public-subnet-1"

      # Required for AWS Load Balancer Controller
      "kubernetes.io/role/elb" = "1"

      # Required for EKS
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"

    }
  )

}

############################################################
# Public Subnet 2
############################################################

resource "aws_subnet" "public2" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.public_subnet_2

  availability_zone = var.az2

  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {

      Name = "public-subnet-2"

      "kubernetes.io/role/elb" = "1"

      "kubernetes.io/cluster/${var.cluster_name}" = "shared"

    }
  )

}

############################################################
# Private Subnet 1
############################################################

resource "aws_subnet" "private1" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_subnet_1

  availability_zone = var.az1

  tags = merge(
    local.common_tags,
    {

      Name = "private-subnet-1"

      # Internal Load Balancer
      "kubernetes.io/role/internal-elb" = "1"

      # EKS Discovery
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"

    }
  )

}

############################################################
# Private Subnet 2
############################################################

resource "aws_subnet" "private2" {

  vpc_id = aws_vpc.main.id

  cidr_block = var.private_subnet_2

  availability_zone = var.az2

  tags = merge(
    local.common_tags,
    {

      Name = "private-subnet-2"

      "kubernetes.io/role/internal-elb" = "1"

      "kubernetes.io/cluster/${var.cluster_name}" = "shared"

    }
  )

}

############################################################
# Elastic IP
#
# Used by NAT Gateway
############################################################

resource "aws_eip" "nat" {

  domain = "vpc"

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "nat-eip"
    }
  )

}

############################################################
# NAT Gateway
############################################################

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public1.id

  tags = merge(
    local.common_tags,
    {
      Name = "nat-gateway"
    }
  )

  depends_on = [
    aws_internet_gateway.igw
  ]

}

############################################################
# Public Route Table
############################################################

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id

  }

  tags = merge(
    local.common_tags,
    {
      Name = "public-route-table"
    }
  )

}

############################################################
# Private Route Table
############################################################

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.main.id

  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat.id

  }

  tags = merge(
    local.common_tags,
    {
      Name = "private-route-table"
    }
  )

}

############################################################
# Associate Public Route Table
############################################################

resource "aws_route_table_association" "public1" {

  subnet_id = aws_subnet.public1.id

  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "public2" {

  subnet_id = aws_subnet.public2.id

  route_table_id = aws_route_table.public.id

}

############################################################
# Associate Private Route Table
############################################################

resource "aws_route_table_association" "private1" {

  subnet_id = aws_subnet.private1.id

  route_table_id = aws_route_table.private.id

}

resource "aws_route_table_association" "private2" {

  subnet_id = aws_subnet.private2.id

  route_table_id = aws_route_table.private.id

}