terraform {
  backend "s3" {
    encrypt        = "true"
    bucket         = "96dcf6978bce8352f0ce0e35f1caaf3f-terraform-remote-state-storage"
    dynamodb_table = "96dcf6978bce8352f0ce0e35f1caaf3f-terraform-remote-state-lock"
    key            = "common/terraform.tfstate"
    region         = "eu-west-1"
    profile        = "sandbox"
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "sandbox"
}

provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = "sandbox"
}

module iac {
  source = "./iac"

  root_domain_name         = "${var.root_domain_name}"
  root_hosted_zone_id      = "${var.root_hosted_zone_id}"
  remote_state_table_name  = "96dcf6978bce8352f0ce0e35f1caaf3f-terraform-remote-state-lock"
  remote_state_bucket_name = "96dcf6978bce8352f0ce0e35f1caaf3f-terraform-remote-state-storage"
}
