module "get_monkeys" {
  source = "../../../../modules/lambda/function"

  func_name = "get-monkeys"
  filename  = "${path.module}/lambda-get_monkeys.zip"
}

module "get_monkeys_api_event" {
  source = "../../../../modules/lambda/events/api_method"
  
  api_id          = "${var.api_id}"
  api_resource_id = "${var.monkeys_path}"
  http_method     = "GET"
  func_invoke_arn = "${module.get_monkeys.invoke_arn}"
}

resource "aws_lambda_permission" "get_monkeys_invoke_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${module.get_monkeys.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.test.execution_arn}/*/*"
}