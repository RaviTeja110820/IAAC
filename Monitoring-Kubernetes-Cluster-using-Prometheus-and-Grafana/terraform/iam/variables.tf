############################################################
# IAM Module Variables
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
# EKS Cluster Name
############################################################
variable "cluster_name" {

  description = "Amazon EKS Cluster Name"

  type = string

}

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
# OIDC Provider URL
#
# This value comes from the EKS cluster after it is created.
#
# Initially leave it as an empty string.
############################################################
variable "oidc_provider_url" {

  description = "OIDC Provider URL"

  type = string

  default = ""

}

############################################################
# OIDC Provider ARN
#
# Used for IAM Roles for Service Accounts (IRSA)
############################################################
variable "oidc_provider_arn" {

  description = "OIDC Provider ARN"

  type = string

  default = ""

}

