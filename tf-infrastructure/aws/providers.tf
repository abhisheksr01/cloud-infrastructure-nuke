terraform {
  /* Below terraform block must be commented out when running for the first time. 🐔 🥚 */
  backend "s3" {}

  required_version = ">= 1.0.1"
  required_providers {
    aws = ">= 3.48.0"
  }
}

provider "aws" {
  region = var.region
  #   assume_role {
  #     role_arn = "arn:aws:iam::${var.account}:role/infra-provisioning-role"
  #   }
}
