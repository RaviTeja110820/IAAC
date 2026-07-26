############################################################
# main.tf
#
# Local Variables
#
# This file contains common tags used throughout the
# Amazon EKS module.
############################################################

locals {

  ##########################################################
  # Common Tags
  ##########################################################

  common_tags = {

    Project = var.project_name

    Environment = var.environment

    ManagedBy = "Terraform"

  }

}