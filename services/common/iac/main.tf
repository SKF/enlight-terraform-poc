provider "aws" {
  region  = "eu-west-1"
  profile = "sandbox"
}

provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = "sandbox"
}

module "public_zone" {
	source = "../../../modules/public_zone"

	domain_name         = "${var.root_domain_name}"
	root_hosted_zone_id = "${var.root_hosted_zone_id}"
}

module "website" {
	source = "../../../modules/website"

	aws_route53_zone_id = "${module.public_zone.zone_id}"
	root_domain_name    = "${var.root_domain_name}"
	acm_certificate_arn = "${module.public_zone.cert_arn}"
}