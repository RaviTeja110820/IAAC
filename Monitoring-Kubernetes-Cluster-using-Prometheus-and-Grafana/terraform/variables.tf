############################################################
# variables.tf
#
# Root Module Variables
############################################################

############################################################
# AWS Account ID
############################################################
variable "aws_account_id" {

  description = "AWS Account ID"

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
# VPC CIDR Block
############################################################
variable "vpc_cidr" {

  description = "VPC CIDR Block"

  type = string

}

############################################################
# Public Subnet 1 CIDR
############################################################
variable "public_subnet_1" {

  description = "Public Subnet 1 CIDR"

  type = string

}

############################################################
# Public Subnet 2 CIDR
############################################################
variable "public_subnet_2" {

  description = "Public Subnet 2 CIDR"

  type = string

}

############################################################
# Private Subnet 1 CIDR
############################################################
variable "private_subnet_1" {

  description = "Private Subnet 1 CIDR"

  type = string

}

############################################################
# Private Subnet 2 CIDR
############################################################
variable "private_subnet_2" {

  description = "Private Subnet 2 CIDR"

  type = string

}

############################################################
# Availability Zone 1
############################################################
variable "az1" {

  description = "Availability Zone 1"

  type = string

}

############################################################
# Availability Zone 2
############################################################
variable "az2" {

  description = "Availability Zone 2"

  type = string

}

############################################################
# Amazon EKS Cluster Name
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
# EC2 Instance Types
############################################################
variable "instance_types" {

  description = "Worker Node Instance Types"

  type = list(string)

  default = [
    "t3.small"
  ]

}

############################################################
# Desired Worker Nodes
############################################################
variable "desired_size" {

  description = "Desired Number of Worker Nodes"

  type = number

  default = 2

}

############################################################
# Minimum Worker Nodes
############################################################
variable "min_size" {

  description = "Minimum Number of Worker Nodes"

  type = number

  default = 2

}

############################################################
# Maximum Worker Nodes
############################################################
variable "max_size" {

  description = "Maximum Number of Worker Nodes"

  type = number

  default = 4

}

############################################################
# Worker Node Disk Size
############################################################
variable "disk_size" {

  description = "Worker Node Root Volume Size"

  type = number

  default = 30

}

############################################################
# Node Group Name
############################################################
variable "node_group_name" {

  description = "Amazon EKS Managed Node Group Name"

  type = string

}

############################################################
# Amazon Linux AMI Type
############################################################
variable "ami_type" {

  description = "Amazon Linux AMI Type"

  type = string

}

############################################################
# Enable Public API Endpoint
############################################################
variable "endpoint_public_access" {

  description = "Enable Public API Endpoint"

  type = bool

  default = true

}

############################################################
# Enable Private API Endpoint
############################################################
variable "endpoint_private_access" {

  description = "Enable Private API Endpoint"

  type = bool

  default = true

}

############################################################
# Allowed API CIDRs
############################################################
variable "public_access_cidrs" {

  description = "Allowed CIDRs for Public API Access"

  type = list(string)

}

############################################################
# Capacity Type
############################################################
variable "capacity_type" {

  description = "Worker Node Capacity Type"

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
# CloudWatch Log Retention
############################################################
variable "log_retention_days" {

  description = "CloudWatch Log Retention"

  type = number

  default = 30

}

############################################################
# Cluster Log Types
############################################################
variable "cluster_log_types" {

  description = "EKS Control Plane Log Types"

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
# Enable IRSA
############################################################
variable "enable_irsa" {

  description = "Enable IAM Roles for Service Accounts"

  type = bool

}

############################################################
# Kubernetes Node Labels
############################################################
variable "node_labels" {

  description = "Worker Node Labels"

  type = map(string)

}

############################################################
# Additional AWS Tags
############################################################
variable "additional_tags" {

  description = "Additional AWS Resource Tags"

  type = map(string)

}


############################################################
# CloudWatch Alarm Email
############################################################
variable "alarm_email" {

  description = "CloudWatch Alert Email"

  type = string

}

############################################################
# CPU Threshold
############################################################
variable "cpu_threshold" {

  description = "CloudWatch CPU Threshold"

  type = number

  default = 80

}

############################################################
# Database Username
############################################################

variable "db_username" {

  type = string

}

############################################################
# Database Password
############################################################

variable "db_password" {

  type = string

  sensitive = true

}

############################################################
# Memory Threshold
############################################################

variable "memory_threshold" {

  description = "Memory Alarm Threshold"

  type = number

  default = 80

}