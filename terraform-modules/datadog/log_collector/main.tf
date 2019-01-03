locals {
  func_name = "datadog-log-collector"
}

module "func" {
  source    = "../../lambda/functions/base"
  func_name = "${local.func_name}"
  filename  = "${path.module}/log_collector.zip"
  bucket    = "${var.bucket}"

  handler = "log_collector.lambda_handler"
  runtime = "python2.7"

  env = {
    "DD_API_KEY" = "${var.datadog_api_key}"
    "DD_TAGS"    = "terraform-zoo"
  }
}
