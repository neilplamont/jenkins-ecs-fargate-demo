/*
The deploy_example.sh script in this directory consumes variables in vars.sh and
then initializes Terraform. The values you see below will be over written by the
deploy_example.sh script and therefore do not need to be updated.
*/

provider "aws" {}

data "aws_region" "current" {}
provider "null" {
}

provider "random" {
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {
}

terraform {
  backend "s3" {
    acl     = "private"
    encrypt = true
    key     = "env:/${terraform.workspace}/terraform.pipeline.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.34.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.1.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
  }

  required_version = ">= 1.2.5"
}
