
variable "jenkins_dns_alias" {
  type        = string
  description = <<EOF
The DNS alias to be associated with the deployed jenkins instance. Alias will
be created in the given route53 zone
EOF
  default     = "jenkins-controller"
}

variable "region" {
  description = "The region in which to build resources."
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID being worked in"
  type        = string
}
