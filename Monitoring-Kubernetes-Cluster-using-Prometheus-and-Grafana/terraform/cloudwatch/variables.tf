############################################################
# CloudWatch Module Variables
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
# Alarm Email
############################################################
variable "alarm_email" {

  description = "Email address for CloudWatch alerts"

  type = string

}

############################################################
# CPU Threshold
############################################################
variable "cpu_threshold" {

  description = "CPU Alarm Threshold"

  type = number

  default = 80

}

############################################################
# Additional Tags
############################################################
variable "additional_tags" {

  description = "Additional AWS Tags"

  type = map(string)

  default = {}

}

############################################################
# Memory Threshold
############################################################

variable "memory_threshold" {

  description = "Memory Alarm Threshold"

  type = number

  default = 80

}

############################################################
# AWS Region
############################################################

variable "aws_region" {

  description = "AWS Region"

  type = string

}

############################################################
# Node Group Name
############################################################

variable "node_group_name" {

  description = "Amazon EKS Node Group Name"

  type = string

}