module "get_monkey" {
  source = "../../../../modules/lambda/function"

  func_name = "get-monkey"
  filename  = "${path.module}/lambda-get_monkey.zip"
  env       = {
    "API_URL" = "https://${var.domain_name}"
  }
}

module "get_monkey_api_event" {
  source = "../../../../modules/lambda/events/api_method"
  
  api_id          = "${var.api_id}"
  api_resource_id = "${var.monkey_id_path}"
  http_method     = "GET"
  func_invoke_arn = "${module.get_monkey.invoke_arn}"
}

resource "aws_lambda_permission" "get_monkey_invoke_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${module.get_monkey.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_execution_arn}/${var.api_stage}/GET/*"
}