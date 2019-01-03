module "public_zone" {
  source = "../../../terraform-modules/public_zone"

  domain_name         = "${var.root_domain_name}"
  root_hosted_zone_id = "${var.root_hosted_zone_id}"
}
