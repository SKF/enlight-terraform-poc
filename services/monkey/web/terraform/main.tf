resource "null_resource" "config_and_upload_web_app" {
  triggers {
    api_url        = "${var.api_url}"
    asset_manifest = "${md5(file("${path.module}/asset-manifest.json"))}"
    manifest       = "${md5(file("${path.module}/manifest.json"))}"
    index          = "${md5(file("${path.module}/index.html"))}"
    favicon        = "${md5(file("${path.module}/favicon.ico"))}"
  }

  provisioner "local-exec" {
    command = <<EOF
    echo 'const config = {' > ${path.module}/config.js
    echo '     "api": "${var.api_url}"' >> ${path.module}/config.js
    echo '};' >> ${path.module}/config.js
    aws s3 sync --profile ${var.aws_profile} --exclude "*.tf" ${path.module}/ s3://${var.bucket}/monkey &&
    aws cloudfront create-invalidation --profile ${var.aws_profile} --distribution-id ${var.cloudfront_id} --paths "/*"
    EOF
  }

  provisioner "local-exec" {
    when = "destroy"

    command = <<EOF
    aws s3 rm --profile ${var.aws_profile} s3://${var.bucket} --recursive
    EOF
  }
}
