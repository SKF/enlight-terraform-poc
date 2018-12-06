resource "aws_api_gateway_method" "path" {
  rest_api_id   = "${var.api_id}"
  resource_id   = "${var.api_resource_id}"
  http_method   = "${var.http_method}"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${var.api_id}"
  resource_id = "${aws_api_gateway_method.path.resource_id}"
  http_method = "${var.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${var.func_invoke_arn}"
}