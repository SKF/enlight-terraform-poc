module "api_gateway" {
  source = "../../../../modules/api_gateway"

  api_name    = "terraform-poc"
  zone_id     = "${module.public_zone.zone_id}"
  domain_name = "${var.api_domain_name}"
}

module "root_options" {
  source = "../../../../modules/options_method"

  api_id      = "${module.api_gateway.id}"
  resource_id = "${module.api_gateway.root_resource_id}"
}

# /monkeys
resource "aws_api_gateway_resource" "monkeys" {
  rest_api_id = "${module.api_gateway.id}"
  parent_id   = "${module.api_gateway.root_resource_id}"
  path_part   = "monkeys"
}

module "monkeys_options" {
  source = "../../../../modules/options_method"

  api_id      = "${module.api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.monkeys.id}"
}

# /monkeys/{monkey_id}
resource "aws_api_gateway_resource" "monkey_id" {
  rest_api_id = "${module.api_gateway.id}"
  parent_id   = "${aws_api_gateway_resource.monkeys.id}"
  path_part   = "{monkey_id}"
}

module "monkey_id_options" {
  source = "../../../../modules/options_method"

  api_id      = "${module.api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.monkey_id.id}"
}
