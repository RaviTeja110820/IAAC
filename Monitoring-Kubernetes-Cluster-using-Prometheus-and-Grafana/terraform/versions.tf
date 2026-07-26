############################################################
# versions.tf
#
# Defines the Terraform version and provider versions.
############################################################

terraform {

  # Minimum Terraform version required
  required_version = ">= 1.6.0"

  # Providers used in this project
  required_providers {

    aws = {

      source  = "hashicorp/aws"

      version = "~> 5.0"

    }

  }

}
