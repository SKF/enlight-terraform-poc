resource "aws_api_gateway_method" "options" {
  rest_api_id   = "${var.api_id}"
  resource_id   = "${var.resource_id}"
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "200" {
  depends_on = ["aws_api_gateway_method.options"]

  rest_api_id = "${var.api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${aws_api_gateway_method.options.http_method}"
  status_code = "200"

  response_models {
    "application/json" = "Empty"
  }

  response_parameters {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = "${var.api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${aws_api_gateway_method.options.http_method}"
  type        = "MOCK"

  request_templates = {
    "application/json" = <<PARAMS
{ "statusCode": 200 }
PARAMS
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  depends_on = ["aws_api_gateway_integration.integration"]

  rest_api_id = "${var.api_id}"
  resource_id = "${var.resource_id}"
  http_method = "${aws_api_gateway_method.options.http_method}"
  status_code = "${aws_api_gateway_method_response.200.status_code}"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "${var.headers}"
    "method.response.header.Access-Control-Allow-Methods" = "${var.methods}"
    "method.response.header.Access-Control-Allow-Origin"  = "${var.origin}"
  }
}
