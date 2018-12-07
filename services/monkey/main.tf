provider "aws" {
  region  = "eu-west-1"
  profile = "sandbox"
}

provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = "sandbox"
}

data "terraform_remote_state" "common_infra" {
  backend = "local"

  config {
    path = "../common/terraform.tfstate"
  }
}

module iac {
  source = "./iac"

  zone_id     = "${data.terraform_remote_state.common_infra.zone_id}"
  domain_name = "${var.api_domain_name}"
}

module backend {
  source     = "./backend/build"
  depends_on = [
    "${module.iac.api_id}",
    "${module.iac.monkeys_path_id}",
    "${module.iac.monkey_id_path_id}"
  ]

  api_id         = "${module.iac.api_id}"
  monkeys_path   = "${module.iac.monkeys_path_id}"
  monkey_id_path = "${module.iac.monkey_id_path_id}"
  api_deployment = "${md5(file("backend/build/main.tf"))}"
  domain_name    = "${var.api_domain_name}"
}

module web {
  source = "./web"

  bucket_id     = "${data.terraform_remote_state.common_infra.website_bucket_id}"
  cloudfront_id = "${data.terraform_remote_state.common_infra.website_cloudfront_id}"
}