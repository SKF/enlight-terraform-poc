data "terraform_remote_state" "common_infra" {
  backend = "local"

  config {
    path = "../common/iac/terraform.tfstate"
  }
}

resource "null_resource" "upload_web_app" {
  provisioner "local-exec" {
    command = <<EOF
    aws s3 sync --profile sandbox ${path.module}/build/ s3://${data.terraform_remote_state.common_infra.website_bucket_id} &&
    aws cloudfront create-invalidation --profile sandbox --distribution-id ${data.terraform_remote_state.common_infra.website_cloudfront_id} --paths /*
    EOF
  }
}
