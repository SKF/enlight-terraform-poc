output "api_id" {
  depends_on = [
    "aws_api_gateway_resource.monkeys",
    "aws_api_gateway_resource.monkeys_id",
  ]

  value = "${module.api_gateway.id}"
}

output "execution_arn" {
  value = "${module.api_gateway.execution_arn}"
}

output "root_path_id" {
  value = "${module.api_gateway.root_resource_id}"
}

output "monkeys_path_id" {
  value = "${aws_api_gateway_resource.monkeys.id}"
}

output "monkey_id_path_id" {
  value = "${aws_api_gateway_resource.monkey_id.id}"
}