module "api_gateway" {
  source = "../../../modules/api_gateway"

  api_name = "terraform-poc"
}

# /monkeys
resource "aws_api_gateway_resource" "monkeys" {
  rest_api_id = "${module.api_gateway.id}"
  parent_id   = "${module.api_gateway.root_resource_id}"
  path_part   = "monkeys"
}

# /monkeys/{proxy+}
resource "aws_api_gateway_resource" "monkey_id" {
  rest_api_id = "${module.api_gateway.id}"
  parent_id   = "${aws_api_gateway_resource.monkeys.id}"
  path_part   = "{proxy+}"
}