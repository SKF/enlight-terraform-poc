resource "aws_route53_zone" "public_zone" {
  name = "${var.domain_name}"
}

resource "aws_route53_record" "zone_ns" {
  zone_id = "${var.root_hosted_zone_id}"
  name    = "${var.domain_name}"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.public_zone.name_servers.0}",
    "${aws_route53_zone.public_zone.name_servers.1}",
    "${aws_route53_zone.public_zone.name_servers.2}",
    "${aws_route53_zone.public_zone.name_servers.3}",
  ]
}

resource "aws_acm_certificate" "cert" {
  provider = "aws.us_east_1"

  domain_name               = "${var.domain_name}"
  subject_alternative_names = ["*.${var.domain_name}"]
  validation_method         = "DNS"
}

resource "aws_route53_record" "cert_validation" {
  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${aws_route53_zone.public_zone.id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  provider = "aws.us_east_1"

  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}