resource "aws_api_gateway_rest_api" "web_api" {
  name        = "${var.api_name}"
  description = "Serverless Application"
}

module "cert" {
  source = "../certificate"

  domain_name = "${var.domain_name}"
  zone_id     = "${var.zone_id}"
}

resource "aws_api_gateway_domain_name" "web_api" {
  certificate_arn = "${module.cert.arn}"
  domain_name     = "${var.domain_name}"
}

resource "aws_route53_record" "web_api" {
  name    = "${var.domain_name}"
  type    = "A"
  zone_id = "${var.zone_id}"

  alias {
    evaluate_target_health = true
    name                   = "${aws_api_gateway_domain_name.web_api.cloudfront_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.web_api.cloudfront_zone_id}"
  }
}