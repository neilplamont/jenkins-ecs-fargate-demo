terraform {
  required_version = ">=1.2.5"

  backend "s3" {
    key = "env:/${terraform.workspace}/terraform.layer000.tfstate"
  }
}

provider "aws" {
  region = var.aws_region
  #allowed_account_ids = [var.account_ids]
}

locals {
  rtags = {
    Environment      = var.Environment
    Service_Provider = "Mycompany"

  }

  Ctags = {
    ApplicationId = var.application_name

  }

  tags = merge(
    local.rtags,
    local.Ctags,
  )

  resource_prefix = "$(var.application_name)-${var.Environment}"

  private_cidr_ranges = [
    cidrsubnet(var.cidr_range, 3, 4),
    cidrsubnet(var.cidr_range, 3, 5),
    cidrsubnet(var.cidr_range, 3, 6),
  ]

  public_cidr_ranges = [
    cidrsubnet(var.cidr_range, 4, 0),
    cidrsubnet(var.cidr_range, 4, 1),
    cidrsubnet(var.cidr_range, 4, 2),
  ]
}

data "aws_availability_zones" "available" {}

######## Networking ########

module "vpc" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-vpc//?ref=v3.18.0"

  azs  = data.aws_availability_zones.available.names
  cidr = var.cidr_range
  //enable_s3_endpoint     = false
  enable_nat_gateway     = true
  name                   = "vpc-01"
  one_nat_gateway_per_az = false
  private_subnets        = local.private_cidr_ranges
  public_subnets         = local.public_cidr_ranges
  single_nat_gateway     = true
  tags                   = local.tags
}
