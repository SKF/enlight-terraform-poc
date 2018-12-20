terraform {
  backend "s3" {
    encrypt        = "true"
    bucket         = "96dcf6978bce8352f0ce0e35f1caaf3f-terraform-remote-state-storage"
    dynamodb_table = "96dcf6978bce8352f0ce0e35f1caaf3f-terraform-remote-state-lock"
    key            = "dev/common/terraform.tfstate"
    region         = "eu-west-1"
    profile        = "sandbox"
  }
}

module base {
  source = "../base"

  root_domain_name         = "${var.root_domain_name}"
  root_hosted_zone_id      = "${var.root_hosted_zone_id}"
  remote_state_table_name  = "96dcf6978bce8352f0ce0e35f1caaf3f-terraform-remote-state-lock"
  remote_state_bucket_name = "96dcf6978bce8352f0ce0e35f1caaf3f-terraform-remote-state-storage"
  aws_service_profile      = "${var.aws_service_profile}"
  aws_root_profile         = "${var.aws_root_profile}"
}
