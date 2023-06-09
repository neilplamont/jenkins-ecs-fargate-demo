# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# AZs
output "azs" {
  description = "A list of availability zones spefified as argument to this module"
  value       = module.vpc.azs
}

#Route53 stuff
output "route53_internal_zone_name" {
  description = "Domain name of the Route53 Internal Zone"
  value       = module.internal_zone.route53_zone_name
}

output "route53_internal_zone_id" {
  description = "Zone ID of the Route53 Internal Zone"
  value       = module.internal_zone.route53_zone_zone_id
}
