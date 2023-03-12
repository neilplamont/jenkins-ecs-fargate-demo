variable "application_name" {
  description = "The name of the application."
  type        = string
}

variable "aws_account_id" {
  description = "The id of the AWS Account to apply changes to."
  type        = string
}

variable "aws_region" {
  description = "AWS region in which to create the state resources"
  type        = string
}

variable "cidr_range" {
  description = "CIDR range for the VPC"
  type        = string
}

variable "Environment" {
  description = "Application environment for which this network is being created. e.g. dev, test, staging, production, etc."
  type        = string
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}
