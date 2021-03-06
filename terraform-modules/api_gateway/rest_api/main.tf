resource "aws_api_gateway_rest_api" "web_api" {
  name        = "${var.api_name}"
  description = "Serverless Application"
}

module "cert" {
  source = "../../certificate"

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

resource "aws_api_gateway_stage" "stage" {
  stage_name           = "${var.stage_name}"
  rest_api_id          = "${aws_api_gateway_rest_api.web_api.id}"
  deployment_id        = "${aws_api_gateway_deployment.deployment.id}"
  xray_tracing_enabled = "true"

  lifecycle {
    ignore_changes = [
      "deployment_id",
    ]
  }
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.web_api.id}"
  stage_name  = "${var.stage_name}"
}

resource "aws_api_gateway_base_path_mapping" "base_path" {
  depends_on = [
    "aws_api_gateway_stage.stage",
  ]

  api_id      = "${aws_api_gateway_rest_api.web_api.id}"
  stage_name  = "${var.stage_name}"
  domain_name = "${var.domain_name}"
}
