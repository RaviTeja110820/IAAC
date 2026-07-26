############################################################
# providers.tf
#
# Configures the AWS Provider.
############################################################

provider "aws" {

  # AWS Region
  region = var.aws_region

}
