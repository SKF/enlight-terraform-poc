provider "aws" {
  region  = "eu-west-1"
  profile = "sandbox"
}

module "public_zone" {
	source = "./modules/public_zone"

	domain_name         = "${var.root_domain_name}"
	root_hosted_zone_id = "${var.root_hosted_zone_id}"
}

module "website" {
	source = "./modules/website"

	aws_route53_zone_id = "${module.public_zone.id}"
	root_domain_name    = "${var.root_domain_name}"
	acm_certificate_arn = "${var.acm_certificate_arn}"
}

resource "aws_s3_bucket_object" "index_html" {
  bucket       = "${module.website.bucket_id}"
  key          = "index.html"
  source       = "./index.html"
  etag         = "${md5(file("./index.html"))}"
  content_type = "text/html"
}