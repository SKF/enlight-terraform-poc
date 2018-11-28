output "zone_id" {
  value = "${aws_route53_zone.public_zone.id}"
}

output "cert_arn" {
  depends_on = ["aws_acm_certificate_validation.cert"]

  value = "${aws_acm_certificate.cert.arn}"
}