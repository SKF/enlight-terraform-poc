output "arn" {
  depends_on = ["aws_acm_certificate_validation.cert"]

  value = "${aws_acm_certificate.cert.arn}"
}