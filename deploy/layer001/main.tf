
locals {
  account_id  = data.aws_caller_identity.current.account_id
  region      = data.aws_region.current.name
  name_prefix = "serverless-jenkins"

  tags = {
    team     = "devops"
    solution = "jenkins"
  }
}

module "myip" {
  source  = "4ops/myip/http"
  version = "1.0.0"
}

data "terraform_remote_state" "base_000" {
  backend = "s3"

  config = {
    bucket = "${var.aws_account_id}-tfstate"
    key    = "env:/${terraform.workspace}/terraform.layer000.tfstate"
    region = var.region
  }
}
/*
// Bring your own ACM cert for the Application Load Balancer
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> v2.0"

  domain_name = "${var.jenkins_dns_alias}.${data.terraform_remote_state.base_000.outputs.route53_internal_zone_name["cicdrandomz.local"]}"
  zone_id     = data.terraform_remote_state.base_000.outputs.route53_internal_zone_id["cicdrandomz.local"]

  tags = local.tags
}
*/
// An example of creating a KMS key
resource "aws_kms_key" "efs_kms_key" {
  description = "KMS key used to encrypt Jenkins EFS volume"
}

module "serverless_jenkins" {
  source                        = "../../modules/jenkins_platform"
  name_prefix                   = local.name_prefix
  tags                          = local.tags
  vpc_id                        = data.terraform_remote_state.base_000.outputs.vpc_id
  efs_kms_key_arn               = aws_kms_key.efs_kms_key.arn
  efs_subnet_ids                = data.terraform_remote_state.base_000.outputs.private_subnets
  jenkins_controller_subnet_ids = data.terraform_remote_state.base_000.outputs.private_subnets
  alb_subnet_ids                = data.terraform_remote_state.base_000.outputs.public_subnets
  alb_ingress_allow_cidrs       = ["${module.myip.address}/32"]
  //alb_acm_certificate_arn       = module.acm.this_acm_certificate_arn
  alb_acm_certificate_arn = "arn:aws:acm:eu-west-2:||accountno||:certificate/updateme"
  route53_create_alias    = true
  route53_alias_name      = "jenkins"
  route53_zone_id         = data.terraform_remote_state.base_000.outputs.route53_internal_zone_id["cicdrandomz.local"]
}

