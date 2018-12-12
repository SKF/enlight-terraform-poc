module "api_gateway" {
  source = "../../../../modules/api_gateway"

  api_name    = "terraform-poc"
  zone_id     = "${var.zone_id}"
  domain_name = "${var.domain_name}"
}

# /monkeys
resource "aws_api_gateway_resource" "monkeys" {
  rest_api_id = "${module.api_gateway.id}"
  parent_id   = "${module.api_gateway.root_resource_id}"
  path_part   = "monkeys"
}

# /monkeys/{monkey_id}
resource "aws_api_gateway_resource" "monkey_id" {
  rest_api_id = "${module.api_gateway.id}"
  parent_id   = "${aws_api_gateway_resource.monkeys.id}"
  path_part   = "{monkey_id}"
}

resource "null_resource" "deploy_api" {
  triggers {
    tf_lambdas_hash   = "${var.tf_lambdas_hash}"
    tf_api_hash       = "${var.tf_api_hash}"
  }

  provisioner "local-exec" {
    command = <<EOF
    aws apigateway create-deployment --rest-api-id ${module.api_gateway.id} --stage-name ${var.api_stage} --profile sandbox
    EOF
  }
}

resource "aws_api_gateway_base_path_mapping" "base_path" {
  depends_on = [
    "null_resource.deploy_api"
  ]

  api_id      = "${module.api_gateway.id}"
  stage_name  = "${var.api_stage}"
  domain_name = "${var.domain_name}"
}