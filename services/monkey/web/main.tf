data "terraform_remote_state" "common_infra" {
  backend = "local"

  config {
    path = "../common/iac/terraform.tfstate"
  }
}

resource "null_resource" "upload_web_app" {
  triggers {
    asset_manifest = "${md5(file("${path.module}/build/asset-manifest.json"))}"
    manifest       = "${md5(file("${path.module}/build/manifest.json"))}"
    index          = "${md5(file("${path.module}/build/index.html"))}"
    favicon        = "${md5(file("${path.module}/build/favicon.ico"))}"
  }

  provisioner "local-exec" {
    command = <<EOF
    aws s3 sync --profile sandbox ${path.module}/build/ s3://${data.terraform_remote_state.common_infra.website_bucket_id} &&
    aws cloudfront create-invalidation --profile sandbox --distribution-id ${data.terraform_remote_state.common_infra.website_cloudfront_id} --paths "/*"
    EOF
  }

  provisioner "local-exec" {
    when = "destroy"
    command = <<EOF
    aws s3 rm --profile sandbox s3://${data.terraform_remote_state.common_infra.website_bucket_id} --recursive
    EOF
  }
}
