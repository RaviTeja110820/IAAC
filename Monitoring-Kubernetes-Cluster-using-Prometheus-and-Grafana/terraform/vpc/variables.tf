############################################################
# VPC Module Variables
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

  description = "Environment Name"

  type = string

}

############################################################
# Kubernetes Cluster Name
#
# Used for subnet tagging so EKS can automatically discover
# public and private subnets.
############################################################
variable "cluster_name" {

  description = "EKS Cluster Name"

  type = string

}

############################################################
# VPC CIDR
############################################################
variable "vpc_cidr" {

  description = "CIDR Block of the VPC"

  type = string

}

############################################################
# Public Subnet 1
############################################################
variable "public_subnet_1" {

  description = "CIDR Block of Public Subnet 1"

  type = string

}

############################################################
# Public Subnet 2
############################################################
variable "public_subnet_2" {

  description = "CIDR Block of Public Subnet 2"

  type = string

}

############################################################
# Private Subnet 1
############################################################
variable "private_subnet_1" {

  description = "CIDR Block of Private Subnet 1"

  type = string

}

############################################################
# Private Subnet 2
############################################################
variable "private_subnet_2" {

  description = "CIDR Block of Private Subnet 2"

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