module "get_donkey" {
  source = "../../../../modules/lambda/functions/api_method"

  func_name = "get-donkey"
  filename  = "${path.module}/lambda-get_donkey.zip"
  bucket    = "${module.lambda_storage.bucket}"

  env = {
    "API_URL" = "https://${var.api_domain_name}"
  }

  api_id            = "${module.api_gateway.id}"
  api_resource_id   = "${aws_api_gateway_resource.donkey_id.id}"
  api_execution_arn = "${module.api_gateway.execution_arn}"
  api_stage         = "${var.api_stage}"
  http_method       = "GET"
  authorization     = "CUSTOM"
  authorizer_id     = "${module.api_authorizer_event.id}"
}
