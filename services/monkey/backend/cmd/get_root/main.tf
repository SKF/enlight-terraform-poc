module "get_root" {
  source = "../../../../modules/lambda/function"

  func_name = "get-root"
  filename  = "${path.module}/lambda-get_root.zip"
  env       = {
    "API_URL" = "https://${var.domain_name}"
  }
}

module "get_root_api_event" {
  source = "../../../../modules/lambda/events/api_method"
  
  api_id          = "${var.api_id}"
  api_resource_id = "${var.root_path}"
  http_method     = "GET"
  func_invoke_arn = "${module.get_root.invoke_arn}"
}

resource "aws_lambda_permission" "get_root_invoke_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${module.get_root.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_execution_arn}/${var.api_stage}/GET/*"
}