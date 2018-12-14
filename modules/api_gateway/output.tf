output "id" {
  depends_on = [
    "aws_api_gateway_domain_name.web_api",
  ]

  value = "${aws_api_gateway_rest_api.web_api.id}"
}

output "execution_arn" {
  value = "${aws_api_gateway_rest_api.web_api.execution_arn}"
}

output "root_resource_id" {
  value = "${aws_api_gateway_rest_api.web_api.root_resource_id}"
}
