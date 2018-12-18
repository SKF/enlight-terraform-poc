resource "null_resource" "config_and_upload_web_app" {
  triggers {
    api_url        = "${var.api_url}"
    asset_manifest = "${md5(file("${path.module}/build/asset-manifest.json"))}"
    manifest       = "${md5(file("${path.module}/build/manifest.json"))}"
    index          = "${md5(file("${path.module}/build/index.html"))}"
    favicon        = "${md5(file("${path.module}/build/favicon.ico"))}"
  }

  provisioner "local-exec" {
    command = <<EOF
    echo 'const config = {' > build/config.js
    echo '     "api": "${var.api_url}"' >> build/config.js
    echo '};' >> build/config.js
    aws s3 sync --profile ${var.aws_profile} ${path.module}/build/ s3://${var.bucket_id} &&
    aws cloudfront create-invalidation --profile ${var.aws_profile} --distribution-id ${var.cloudfront_id} --paths "/*"
    EOF
  }

  provisioner "local-exec" {
    when = "destroy"

    command = <<EOF
    aws s3 rm --profile ${var.aws_profile} s3://${var.bucket_id} --recursive
    EOF
  }
}
