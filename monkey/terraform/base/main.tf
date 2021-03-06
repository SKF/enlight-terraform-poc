provider "aws" {
  region  = "eu-west-1"
  profile = "${var.aws_service_profile}"
}

provider "aws" {
  alias   = "global"
  region  = "us-east-1"
  profile = "${var.aws_service_profile}"
}

provider "aws" {
  alias   = "root"
  region  = "eu-west-1"
  profile = "${var.aws_root_profile}"
}

module backend {
  source = "../../backend/build"

  root_hosted_zone_id = "${var.public_zone_id}"
  root_domain_name    = "${var.root_domain_name}"
  api_domain_name     = "${var.api_domain_name}"
  api_stage           = "${var.api_stage}"
  datadog_api_key     = "${var.datadog_api_key}"
  datadog_app_key     = "${var.datadog_app_key}"
}

# The deploy is in this file due to unresolved dependency issues when having it in the Backend module.
resource "null_resource" "deploy_api" {
  depends_on = [
    "module.backend",
  ]

  triggers {
    tf_lambdas_hash = "${md5(file("${path.module}/../../backend/build/lambdas.tf"))}"
    tf_api_hash     = "${md5(file("${path.module}/../../backend/build/api_gateway.tf"))}"
  }

  provisioner "local-exec" {
    command = <<EOF
    aws apigateway create-deployment --rest-api-id ${module.backend.api_id} --stage-name ${var.api_stage} --profile ${var.aws_service_profile}
    EOF
  }
}

module web {
  source = "../../web/build"

  bucket        = "${var.website_bucket}"
  cloudfront_id = "${var.website_cloudfront_id}"
  api_url       = "https://${var.api_domain_name}"
  aws_profile   = "${var.aws_common_profile}"
}
