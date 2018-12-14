module "public_zone" {
  source = "../../../modules/public_zone"

  domain_name         = "${var.root_domain_name}"
  root_hosted_zone_id = "${var.root_hosted_zone_id}"
}

module "website" {
  source = "../../../modules/website"

  aws_route53_zone_id = "${module.public_zone.zone_id}"
  root_domain_name    = "${var.root_domain_name}"
}

module "remote_state" {
  source = "../../../modules/remote_state"

  table_name  = "${var.remote_state_table_name}"
  bucket_name = "${var.remote_state_bucket_name}"
}
