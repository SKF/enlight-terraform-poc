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
