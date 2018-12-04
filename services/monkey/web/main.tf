provider "aws" {
  region  = "eu-west-1"
  profile = "sandbox"
}

data "terraform_remote_state" "common_infra" {
  backend = "local"

  config {
    path = "../../common/iac/terraform.tfstate"
  }
}

resource "null_resource" "yarn_build" {
  provisioner "local-exec" {
    command = <<EOF
    cd app && 
    yarn install &&
    yarn build && 
    aws s3 sync --profile sandbox build/ s3://${data.terraform_remote_state.common_infra.website_bucket_id} &&
    aws cloudfront create-invalidation --profile sandbox --distribution-id ${data.terraform_remote_state.common_infra.website_cloudfront_id} --paths /*
    EOF
  }
}
