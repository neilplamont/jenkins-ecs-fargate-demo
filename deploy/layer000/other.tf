module "internal_zone" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.10.0"

  zones = {
    "cicdrandomz.local" = {
      comment = "Local DNS Zone for cicd stuffs"
      tags = {
        env = "dev"
      }
    }

    "cicdrandomz.local" = {
      comment = "cicdrandomz.local"
    }
  }

  tags = {
    ManagedBy = "Terraform"
  }
}

/*
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.10.0"

  zone_name = keys(module.zones.route53_zone_zone_id)[0]

  records = [
    {
      name    = "jenkins"
      type    = "A"
      alias   = {
        name    = "XXXXXXXXX.execute-api.eu-west-1.amazonaws.com"
        zone_id = "XXXXXXXXXX"
      }
    },
    {
      name    = ""
      type    = "A"
      ttl     = 3600
      records = [
        "10.10.10.10",
      ]
    },
  ]

  depends_on = [module.zones]
}
*/
