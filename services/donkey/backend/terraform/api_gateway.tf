module "api_gateway" {
  source = "../../../../modules/api_gateway/rest_api"

  api_name    = "donkey"
  zone_id     = "${module.public_zone.zone_id}"
  domain_name = "${var.api_domain_name}"
}

module "root_options" {
  source = "../../../../modules/api_gateway/options_method"

  api_id      = "${module.api_gateway.id}"
  resource_id = "${module.api_gateway.root_resource_id}"
}

# /donkeys
resource "aws_api_gateway_resource" "donkeys" {
  rest_api_id = "${module.api_gateway.id}"
  parent_id   = "${module.api_gateway.root_resource_id}"
  path_part   = "donkeys"
}

module "donkeys_options" {
  source = "../../../../modules/api_gateway/options_method"

  api_id      = "${module.api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.donkeys.id}"
}

# /donkeys/{donkey_id}
resource "aws_api_gateway_resource" "donkey_id" {
  rest_api_id = "${module.api_gateway.id}"
  parent_id   = "${aws_api_gateway_resource.donkeys.id}"
  path_part   = "{donkey_id}"
}

module "donkey_id_options" {
  source = "../../../../modules/api_gateway/options_method"

  api_id      = "${module.api_gateway.id}"
  resource_id = "${aws_api_gateway_resource.donkey_id.id}"
}
