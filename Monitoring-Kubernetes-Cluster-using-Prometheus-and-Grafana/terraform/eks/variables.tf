############################################################
# Amazon EKS Module Variables
#
# These variables are passed from the root module.
############################################################

############################################################
# Project Name
############################################################
variable "project_name" {

  description = "Project Name"

  type = string

}

############################################################
# Environment
############################################################
variable "environment" {

  description = "Deployment Environment"

  type = string

}

############################################################
# AWS Region
############################################################
variable "aws_region" {

  description = "AWS Region"

  type = string

}

############################################################
# EKS Cluster Name
############################################################
variable "cluster_name" {

  description = "Amazon EKS Cluster Name"

  type = string

}

############################################################
# Kubernetes Version
############################################################
variable "kubernetes_version" {

  description = "Amazon EKS Kubernetes Version"

  type = string

  default = "1.30"

  validation {

    condition = contains(
      ["1.30"],
      var.kubernetes_version
    )

    error_message = "Supported Kubernetes version is 1.30."

  }

}

############################################################
# VPC ID
############################################################
variable "vpc_id" {

  description = "VPC ID"

  type = string

}

############################################################
# Private Subnet 1 ID
############################################################
variable "private_subnet_1_id" {

  description = "Private Subnet 1 ID"

  type = string

}

############################################################
# Private Subnet 2 ID
############################################################
variable "private_subnet_2_id" {

  description = "Private Subnet 2 ID"

  type = string

}

############################################################
# Public Subnet 1 ID
############################################################
variable "public_subnet_1_id" {

  description = "Public Subnet 1 ID"

  type = string

}

############################################################
# Public Subnet 2 ID
############################################################
variable "public_subnet_2_id" {

  description = "Public Subnet 2 ID"

  type = string

}

############################################################
# EKS Cluster IAM Role ARN
############################################################
variable "eks_cluster_role_arn" {

  description = "IAM Role ARN for Amazon EKS Cluster"

  type = string

}

############################################################
# Worker Node IAM Role ARN
############################################################
variable "node_group_role_arn" {

  description = "IAM Role ARN for Amazon EKS Managed Node Group"

  type = string

}

############################################################
# EC2 Instance Types
############################################################
variable "instance_types" {

  description = "EC2 Instance Types"

  type = list(string)

  default = [
    "t3.small"
  ]

}

############################################################
# Desired Worker Nodes
############################################################
variable "desired_size" {

  description = "Desired Worker Nodes"

  type = number

  default = 2

}

############################################################
# Minimum Worker Nodes
############################################################
variable "min_size" {

  description = "Minimum Worker Nodes"

  type = number

  default = 2

}

############################################################
# Maximum Worker Nodes
############################################################
variable "max_size" {

  description = "Maximum Worker Nodes"

  type = number

  default = 4

}

############################################################
# Worker Node Root Volume Size
############################################################
variable "disk_size" {

  description = "Worker Node Root Volume Size (GB)"

  type = number

  default = 30

}

############################################################
# Endpoint Public Access
############################################################
variable "endpoint_public_access" {

  description = "Enable Public Kubernetes API Endpoint"

  type = bool

  default = true

}

############################################################
# Endpoint Private Access
############################################################
variable "endpoint_private_access" {

  description = "Enable Private Kubernetes API Endpoint"

  type = bool

  default = true

}

############################################################
# CloudWatch Log Retention
############################################################
variable "log_retention_days" {

  description = "CloudWatch Log Retention (Days)"

  type = number

  default = 30

}

############################################################
# Control Plane Logs
############################################################
variable "cluster_log_types" {

  description = "EKS Control Plane Logs"

  type = list(string)

  default = [

    "api",

    "audit",

    "authenticator",

    "controllerManager",

    "scheduler"

  ]

}

############################################################
# Capacity Type
############################################################
variable "capacity_type" {

  description = "Node Group Capacity Type"

  type = string

  default = "ON_DEMAND"

  validation {

    condition = contains(
      ["ON_DEMAND", "SPOT"],
      var.capacity_type
    )

    error_message = "capacity_type must be ON_DEMAND or SPOT."

  }

}

############################################################
# Node Group Name
############################################################
variable "node_group_name" {

  description = "Amazon EKS Managed Node Group Name"

  type = string

  default = "enterprise-node-group"

}

############################################################
# Worker Node AMI Type
############################################################
variable "ami_type" {

  description = "Amazon EKS Worker Node AMI"

  type = string

  default = "AL2023_x86_64_STANDARD"

}

############################################################
# Public API Allowed CIDRs
############################################################
variable "public_access_cidrs" {

  description = "Allowed CIDRs for Kubernetes API"

  type = list(string)

  default = [

    "0.0.0.0/0"

  ]

}

############################################################
# Enable IAM Roles for Service Accounts
############################################################
variable "enable_irsa" {

  description = "Enable IAM Roles for Service Accounts (IRSA)"

  type = bool

  default = true

}

############################################################
# Kubernetes Node Labels
############################################################
variable "node_labels" {

  description = "Labels applied to Worker Nodes"

  type = map(string)

  default = {

    Environment = "dev"

    Project = "enterprise-devops"

  }

}

############################################################
# Additional AWS Resource Tags
############################################################
variable "additional_tags" {

  description = "Additional AWS Resource Tags"

  type = map(string)

  default = {}

}