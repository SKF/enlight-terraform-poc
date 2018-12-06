output "api_id" {
  value = "${module.api_gateway.id}"
}

output "monkeys_path_id" {
  value = "${aws_api_gateway_resource.monkeys.id}"
}

output "monkey_id_path_id" {
  value = "${aws_api_gateway_resource.monkey_id.id}"
}


