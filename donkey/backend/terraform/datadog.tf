module "log_collector" {
  source          = "../../../common/terraform/modules/datadog/log_collector"
  datadog_api_key = "${var.datadog_api_key}"
  bucket          = "${module.lambda_storage.bucket}"
}

module "metrics_integration" {
  source          = "../../../common/terraform/modules/datadog/metrics_integration"
  datadog_api_key = "${var.datadog_api_key}"
  datadog_app_key = "${var.datadog_app_key}"
}
