resource "aws_api_gateway_method" "path" {
  rest_api_id   = "${var.api_id}"
  resource_id   = "${var.api_resource_id}"
  http_method   = "${var.http_method}"
  authorization = "${var.authorization}"
  authorizer_id = "${var.authorizer_id}"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_method.path.resource_id}"
  http_method = "${var.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${var.func_invoke_arn}"
}

resource "aws_lambda_permission" "get_monkeys_invoke_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${var.func_arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_execution_arn}/${var.api_stage}/${var.http_method}/*"
}