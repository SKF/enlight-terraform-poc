terraform {
  backend "s3" {
    encrypt        = "true"
    bucket         = "96dcf6978bce8352f0ce0e35f1caaf3f-terraform-remote-state-storage"
    dynamodb_table = "96dcf6978bce8352f0ce0e35f1caaf3f-terraform-remote-state-lock"
    key            = "dev/donkey/terraform.tfstate"
    region         = "eu-west-1"
    profile        = "sandbox"
  }
}

data "terraform_remote_state" "common_infra" {
  backend = "s3"

  config {
    encrypt        = "true"
    bucket         = "96dcf6978bce8352f0ce0e35f1caaf3f-terraform-remote-state-storage"
    dynamodb_table = "96dcf6978bce8352f0ce0e35f1caaf3f-terraform-remote-state-lock"
    key            = "dev/common/terraform.tfstate"
    region         = "eu-west-1"
    profile        = "sandbox"
  }
}

module base {
  source                = "../base"
  root_domain_name      = "${var.root_domain_name}"
  api_domain_name       = "${var.api_domain_name}"
  aws_service_profile   = "${var.aws_service_profile}"
  aws_root_profile      = "${var.aws_root_profile}"
  aws_common_profile    = "${var.aws_common_profile}"
  public_zone_id        = "${data.terraform_remote_state.common_infra.public_zone_id}"
  website_bucket        = "${data.terraform_remote_state.common_infra.website_buckets["donkey"]}"
  website_cloudfront_id = "${data.terraform_remote_state.common_infra.website_cloudfront_id}"
  datadog_api_key       = "${var.datadog_api_key}"
  datadog_app_key       = "${var.datadog_app_key}"
}
