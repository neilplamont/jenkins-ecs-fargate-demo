/*terraform {
  required_version = ">=0.14.5"

  backend "s3" {
    key    = "terraform.vpc.tfstate"
    region = var.aws_region
  }
}
*/

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  tags = {
    team     = "devops"
    solution = "jenkins"
  }
}

resource "aws_s3_bucket" "this" {
  bucket = "account-tfstate"

  tags = {
    Environment     = "Global"
    Name            = "Terraform State"
    ServiceProvider = "Mycompany"
    Terraform       = "true"
  }
}

resource "aws_s3_bucket_acl" "acl_state" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      //kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm = "AES256"
    }


  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    id = "statefile"

    expiration {
      days = 90
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }
}


resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "this" {
  name           = "terraform_lock_accountno"
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5
  #billing_mode   = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }

  # tags {
  #   Name = "DynamoDB Terraform State Lock Table"
  # }
}
