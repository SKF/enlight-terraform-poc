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

  root_domain_name    = "${var.root_domain_name}"
  root_hosted_zone_id = "${var.root_hosted_zone_id}"
}