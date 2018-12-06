resource "aws_api_gateway_rest_api" "web_api" {
  name        = "${var.api_name}"
  description = "Serverless Application"
}