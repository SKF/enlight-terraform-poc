module "get_monkeys" {
  source = "../../../../modules/lambda/functions/api_method"

  func_name = "get-monkeys"
  filename  = "${path.module}/lambda-get_monkeys.zip"

  env = {
    "API_URL" = "https://${var.domain_name}"
  }

  api_id            = "${module.api_gateway.id}"
  api_resource_id   = "${aws_api_gateway_resource.monkeys.id}"
  api_execution_arn = "${module.api_gateway.execution_arn}"
  api_stage         = "${var.api_stage}"
  http_method       = "GET"
  authorization     = "CUSTOM"
  authorizer_id     = "${module.api_authorizer_event.id}"
}
