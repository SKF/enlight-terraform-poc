module "get_monkey" {
  source = "../../../../modules/lambda/functions/api_method"

  func_name = "get-monkey"
  filename  = "${path.module}/lambda-get_monkey.zip"
  bucket    = "${var.lambda_storage_bucket}"

  env = {
    "API_URL" = "https://${var.domain_name}"
  }

  api_id            = "${module.api_gateway.id}"
  api_resource_id   = "${aws_api_gateway_resource.monkey_id.id}"
  api_execution_arn = "${module.api_gateway.execution_arn}"
  api_stage         = "${var.api_stage}"
  http_method       = "GET"
  authorization     = "CUSTOM"
  authorizer_id     = "${module.api_authorizer_event.id}"
}
