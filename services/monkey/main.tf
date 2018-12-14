terraform {
  backend "s3" {
    encrypt        = "true"
    bucket         = "96dcf6978bce8352f0ce0e35f1caaf3f-terraform-remote-state-storage"
    dynamodb_table = "96dcf6978bce8352f0ce0e35f1caaf3f-terraform-remote-state-lock"
    key            = "monkey/terraform.tfstate"
    region         = "eu-west-1"
    profile        = "sandbox"
  }
}

provider "aws" {
  region  = "eu-west-1"
  profile = "sandbox"
}

provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = "sandbox"
}

data "terraform_remote_state" "common_infra" {
  backend = "s3"

  config {
    encrypt        = "true"
    bucket         = "96dcf6978bce8352f0ce0e35f1caaf3f-terraform-remote-state-storage"
    dynamodb_table = "96dcf6978bce8352f0ce0e35f1caaf3f-terraform-remote-state-lock"
    key            = "common/terraform.tfstate"
    region         = "eu-west-1"
    profile        = "sandbox"
  }
}

module backend {
  source = "./backend/build"

  zone_id     = "${data.terraform_remote_state.common_infra.public_zone_id}"
  domain_name = "${var.api_domain_name}"
  api_stage   = "${var.api_stage}"
}

# The deploy is in this file due to unresolved dependency issues when having it in the Backend module.
resource "null_resource" "deploy_api" {
  depends_on = [
    "module.backend",
  ]

  triggers {
    tf_lambdas_hash = "${md5(file("backend/build/lambdas.tf"))}"
    tf_api_hash     = "${md5(file("backend/build/api_gateway.tf"))}"
  }

  provisioner "local-exec" {
    command = <<EOF
    aws apigateway create-deployment --rest-api-id ${module.backend.api_id} --stage-name ${var.api_stage} --profile sandbox
    EOF
  }
}

resource "aws_api_gateway_base_path_mapping" "base_path" {
  depends_on = [
    "null_resource.deploy_api",
  ]

  api_id      = "${module.backend.api_id}"
  stage_name  = "${var.api_stage}"
  domain_name = "${var.api_domain_name}"
}

module web {
  source = "./web"

  bucket_id     = "${data.terraform_remote_state.common_infra.website_bucket_id}"
  cloudfront_id = "${data.terraform_remote_state.common_infra.website_cloudfront_id}"
}
